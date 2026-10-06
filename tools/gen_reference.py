#!/usr/bin/env python3
"""Generate the docs/reference/*.md catalogs from the active PSoul source.

Usage: python3 tools/gen_reference.py [--only NAME[,NAME...]] [--check]

Reads (never executes) the server/client source:
  * Lua configs are evaluated by a small, tolerant, pure-Python interpreter that understands
    table constructors, assignments, table.deepcopy/table.insert and skips every function
    body and control-flow block.  Anything it cannot evaluate is kept as a symbolic string
    (the original source text), so nothing is invented.
  * XML files are read with xml.etree, falling back to regular expressions.
  * SQL schemas and code references are found with regular expressions (heuristic, see
    the notes in each generated file).

Only the Python 3 standard library is used.  Output: docs/reference/{COMMANDS,POKEMON,MOVES,
POKEBALLS,ITEMS,NPCS,QUESTS,ACHIEVEMENTS,DATABASE}.md
"""

import argparse
import copy
import math
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from collections import OrderedDict, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SERVER = os.path.join(ROOT, "server")
DATA = os.path.join(SERVER, "data")
SRC = os.path.join(SERVER, "src")
CLIENT = os.path.join(ROOT, "client")
PSLIB = os.path.join(DATA, "lib", "ps")
PSCONF = os.path.join(PSLIB, "config")
OUTDIR = os.path.join(ROOT, "docs", "reference")

# Trees that exist on disk but are never loaded by the server (non-recursive loader, no dofile).
HISTORICAL_DIRS = [
    os.path.join(PSCONF, "_pokemon"),
    os.path.join(PSLIB, "others", "pokemon_backup"),
    os.path.join(PSLIB, "others", "moves_disabled"),
    os.path.join(PSLIB, "systems", "disabled"),
    os.path.join(DATA, "lib", "disabled"),
]


def rel(path):
    return os.path.relpath(path, ROOT).replace(os.sep, "/")


def read(path):
    with open(path, "rb") as f:
        raw = f.read()
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw.decode("latin-1")


def is_historical(path):
    ap = os.path.abspath(path)
    return any(ap == d or ap.startswith(d + os.sep) for d in HISTORICAL_DIRS)


def git_commit():
    try:
        return subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], cwd=ROOT,
                                       stderr=subprocess.DEVNULL).decode().strip()
    except Exception:
        return "unknown"


# ---------------------------------------------------------------------------------------------
# Lua tokenizer
# ---------------------------------------------------------------------------------------------

LUA_KEYWORDS = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto",
                "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true",
                "until", "while"}

_LUA_OPS = ["...", "..", "==", "~=", "<=", ">=", "::", "<<", ">>", "//",
            "+", "-", "*", "/", "%", "^", "#", "&", "~", "|", "<", ">", "=", "(", ")", "{", "}",
            "[", "]", ";", ":", ",", "."]


class Tok(object):
    __slots__ = ("kind", "val", "start", "end", "line")

    def __init__(self, kind, val, start, end, line):
        self.kind, self.val, self.start, self.end, self.line = kind, val, start, end, line

    def __repr__(self):
        return "Tok(%s,%r)" % (self.kind, self.val)


def _long_bracket(src, i):
    """If src[i] starts a long bracket ([[ or [==[) return (level, content_start) else None."""
    m = re.match(r"\[(=*)\[", src[i:i + 64])
    if not m:
        return None
    return len(m.group(1)), i + m.end()


def lua_tokenize(src):
    toks = []
    i, n, line = 0, len(src), 1
    while i < n:
        c = src[i]
        if c == "\n":
            line += 1
            i += 1
            continue
        if c in " \t\r\f\v":
            i += 1
            continue
        if src.startswith("--", i):
            lb = _long_bracket(src, i + 2)
            if lb:
                close = "]" + "=" * lb[0] + "]"
                j = src.find(close, lb[1])
                j = n if j < 0 else j + len(close)
            else:
                j = src.find("\n", i)
                j = n if j < 0 else j
            line += src.count("\n", i, j)
            i = j
            continue
        if c == "[":
            lb = _long_bracket(src, i)
            if lb:
                close = "]" + "=" * lb[0] + "]"
                j = src.find(close, lb[1])
                j = n if j < 0 else j
                s = src[lb[1]:j]
                if s.startswith("\n"):
                    s = s[1:]
                end = min(n, j + len(close))
                toks.append(Tok("str", s, i, end, line))
                line += src.count("\n", i, end)
                i = end
                continue
        if c in "\"'":
            j = i + 1
            buf = []
            while j < n and src[j] != c:
                if src[j] == "\\" and j + 1 < n:
                    e = src[j + 1]
                    mapping = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", "'": "'", '"': '"',
                               "a": "\a", "b": "\b", "f": "\f", "v": "\v", "\n": "\n"}
                    if e in mapping:
                        buf.append(mapping[e])
                        j += 2
                    elif e.isdigit():
                        m = re.match(r"\d{1,3}", src[j + 1:j + 4])
                        buf.append(chr(int(m.group(0)) % 256))
                        j += 1 + len(m.group(0))
                    else:
                        buf.append(e)
                        j += 2
                    continue
                if src[j] == "\n":  # unterminated string: stop at end of line
                    break
                buf.append(src[j])
                j += 1
            toks.append(Tok("str", "".join(buf), i, j + 1, line))
            i = j + 1
            continue
        if c.isdigit() or (c == "." and i + 1 < n and src[i + 1].isdigit()):
            m = re.match(r"0[xX][0-9a-fA-F]+|(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?", src[i:])
            txt = m.group(0)
            if txt.lower().startswith("0x"):
                v = int(txt, 16)
            elif re.match(r"^\d+$", txt):
                v = int(txt)
            else:
                v = float(txt)
            toks.append(Tok("num", v, i, i + len(txt), line))
            i += len(txt)
            continue
        if c.isalpha() or c == "_":
            m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", src[i:])
            w = m.group(0)
            toks.append(Tok("kw" if w in LUA_KEYWORDS else "name", w, i, i + len(w), line))
            i += len(w)
            continue
        for op in _LUA_OPS:
            if src.startswith(op, i):
                toks.append(Tok("op", op, i, i + len(op), line))
                i += len(op)
                break
        else:
            i += 1  # unknown character: skip
    toks.append(Tok("eof", None, n, n, line))
    return toks


def strip_lua_comments(src):
    """Return src with every Lua comment replaced by spaces (line structure preserved)."""
    out = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if src.startswith("--", i):
            lb = _long_bracket(src, i + 2)
            if lb:
                close = "]" + "=" * lb[0] + "]"
                j = src.find(close, lb[1])
                j = n if j < 0 else j + len(close)
            else:
                j = src.find("\n", i)
                j = n if j < 0 else j
            out.append(re.sub(r"[^\n]", " ", src[i:j]))
            i = j
            continue
        if c in "\"'":
            j = i + 1
            while j < n and src[j] != c and src[j] != "\n":
                j += 2 if src[j] == "\\" else 1
            out.append(src[i:j + 1])
            i = j + 1
            continue
        if c == "[":
            lb = _long_bracket(src, i)
            if lb:
                close = "]" + "=" * lb[0] + "]"
                j = src.find(close, lb[1])
                j = n if j < 0 else j + len(close)
                out.append(src[i:j])
                i = j
                continue
        out.append(c)
        i += 1
    return "".join(out)


def strip_c_comments(src):
    src = re.sub(r"/\*.*?\*/", lambda m: re.sub(r"[^\n]", " ", m.group(0)), src, flags=re.S)
    return re.sub(r"//[^\n]*", "", src)


def strip_xml_comments(src):
    return re.sub(r"<!--.*?-->", lambda m: re.sub(r"[^\n]", " ", m.group(0)), src, flags=re.S)


# ---------------------------------------------------------------------------------------------
# Lua values
# ---------------------------------------------------------------------------------------------

class LTable(object):
    """Lua table: ordered hash part; integer keys 1..n form the array part."""

    def __init__(self):
        self.h = OrderedDict()

    def get(self, k, default=None):
        k = _norm_key(k)
        return self.h.get(k, default)

    def set(self, k, v):
        k = _norm_key(k)
        if v is None:
            self.h.pop(k, None)
        else:
            self.h[k] = v

    def __contains__(self, k):
        return _norm_key(k) in self.h

    def arr(self):
        out = []
        i = 1
        while i in self.h:
            out.append(self.h[i])
            i += 1
        return out

    def items(self):
        return self.h.items()

    def keys(self):
        return self.h.keys()

    def values(self):
        return self.h.values()

    def __len__(self):
        return len(self.arr())

    def __bool__(self):
        return True

    def __deepcopy__(self, memo):
        t = LTable()
        memo[id(self)] = t
        for k, v in self.h.items():
            t.h[k] = copy.deepcopy(v, memo)
        return t

    def __repr__(self):
        return "LTable(%r)" % dict(self.h)


def _norm_key(k):
    if isinstance(k, float) and k.is_integer():
        return int(k)
    if isinstance(k, Sym):
        return ("sym", k.text)
    return k


class Sym(object):
    """An expression the interpreter could not evaluate; keeps the source text."""
    __slots__ = ("text", "missing")

    def __init__(self, text, missing=False):
        self.text = text
        self.missing = missing  # True: a field of a known table that does not exist (nil)

    def __repr__(self):
        return "Sym(%s)" % self.text

    def __deepcopy__(self, memo):
        return self


class Func(object):
    __slots__ = ("text", "line")

    def __init__(self, text, line):
        self.text, self.line = text, line

    def __repr__(self):
        return "Func(line %d)" % self.line

    def __deepcopy__(self, memo):
        return self


def is_num(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)


class LuaEnv(object):
    """Global environment shared by several files."""

    def __init__(self, keep_on_nil=True):
        self.g = {}
        self.keep_on_nil = keep_on_nil
        self.call_hooks = {}   # dotted name -> fn(interp, args, argtexts)
        self.warnings = []     # (file, line, message)
        self.assign_log = []   # (file, line, lvalue-text)

    def run_file(self, path, local_scope=None):
        src = read(path)
        it = LuaInterp(self, src, path, local_scope)
        it.chunk()
        return it


class LuaParseError(Exception):
    pass


BINPRI = {"or": (1, 1), "and": (2, 2), "<": (3, 3), ">": (3, 3), "<=": (3, 3), ">=": (3, 3),
          "~=": (3, 3), "==": (3, 3), "|": (4, 4), "~": (5, 5), "&": (6, 6), "<<": (7, 7),
          ">>": (7, 7), "..": (9, 8), "+": (10, 10), "-": (10, 10), "*": (11, 11),
          "/": (11, 11), "//": (11, 11), "%": (11, 11), "^": (14, 13)}
UNARY_PRI = 12


class LuaInterp(object):
    def __init__(self, env, src, path, local_scope=None):
        self.env = env
        self.src = src
        self.path = path
        self.toks = lua_tokenize(src)
        self.i = 0
        self.locals = local_scope if local_scope is not None else {}

    # -- token helpers --------------------------------------------------------------------
    @property
    def t(self):
        return self.toks[self.i]

    def peek(self, k=1):
        return self.toks[min(self.i + k, len(self.toks) - 1)]

    def is_op(self, v, tok=None):
        tok = tok or self.t
        return tok.kind == "op" and tok.val == v

    def is_kw(self, v, tok=None):
        tok = tok or self.t
        return tok.kind == "kw" and tok.val == v

    def adv(self):
        tok = self.toks[self.i]
        if tok.kind != "eof":
            self.i += 1
        return tok

    def expect_op(self, v):
        if not self.is_op(v):
            raise LuaParseError("%s:%d expected %r got %r" % (rel(self.path), self.t.line, v,
                                                              self.t.val))
        return self.adv()

    def text(self, a, b):
        return self.src[a:b]

    def warn(self, msg, line=None):
        self.env.warnings.append((rel(self.path), line or self.t.line, msg))

    # -- name resolution ---------------------------------------------------------------------
    def lookup(self, name):
        if name in self.locals:
            return self.locals[name]
        if name in self.env.g:
            return self.env.g[name]
        return Sym(name)

    def store(self, name, v, is_local=False):
        if is_local:
            self.locals[name] = v
        elif name in self.locals:
            if v is not None or not self.env.keep_on_nil:
                self.locals[name] = v
        else:
            if v is None and self.env.keep_on_nil:
                return
            self.env.g[name] = v

    # -- block skipping ------------------------------------------------------------------------
    def skip_block(self):
        """Current token opens a block (function/if/do/while/for/repeat); skip to its end."""
        depth = 0
        while self.t.kind != "eof":
            tok = self.adv()
            if tok.kind != "kw":
                continue
            if tok.val in ("function", "if", "do", "repeat"):
                # 'while'/'for' are closed by the 'end' of their 'do'
                depth += 1
            elif tok.val == "end":
                depth -= 1
                if depth <= 0:
                    return
            elif tok.val == "until":
                depth -= 1
                if depth <= 0:
                    try:
                        self.expr()
                    except LuaParseError:
                        pass
                    return

    # -- statements ------------------------------------------------------------------------------
    def chunk(self):
        while self.t.kind != "eof":
            start = self.i
            try:
                if not self.statement():
                    break
            except LuaParseError as e:
                self.warn("parse error: %s" % e)
                # resynchronise: skip to the next line start
                line = self.toks[start].line
                if self.i == start:
                    self.adv()
                while self.t.kind != "eof" and self.t.line == line:
                    self.adv()

    def statement(self):
        t = self.t
        if self.is_op(";"):
            self.adv()
            return True
        if t.kind == "kw":
            if t.val == "local":
                self.adv()
                if self.is_kw("function"):
                    i0, a, line = self.i, self.t.start, self.t.line
                    self.adv()
                    name = self.adv().val
                    self.i = i0
                    self.skip_block()
                    self.store(name, Func(self.text(a, self.toks[self.i - 1].end), line), True)
                    return True
                names = []
                while True:
                    names.append(self.adv().val)
                    if self.is_op("<"):  # Lua 5.4 attribs
                        while not self.is_op(">"):
                            self.adv()
                        self.adv()
                    if self.is_op(","):
                        self.adv()
                        continue
                    break
                vals = []
                if self.is_op("="):
                    self.adv()
                    vals = self.explist()
                for k, nm in enumerate(names):
                    self.store(nm, vals[k] if k < len(vals) else None, True)
                return True
            if t.val == "function":
                i0, a, line = self.i, t.start, t.line
                # function a.b.c:d(...)
                self.adv()
                parts = [self.adv().val]
                while self.is_op(".") or self.is_op(":"):
                    self.adv()
                    parts.append(self.adv().val)
                self.i = i0
                self.skip_block()
                f = Func(self.text(a, self.toks[self.i - 1].end), line)
                if len(parts) == 1:
                    self.store(parts[0], f)
                else:
                    base = self.lookup(parts[0])
                    for p in parts[1:-1]:
                        base = base.get(p) if isinstance(base, LTable) else None
                    if isinstance(base, LTable):
                        base.set(parts[-1], f)
                return True
            if t.val in ("if", "do", "while", "for", "repeat"):
                self.skip_block()
                return True
            if t.val == "return":
                return False
            if t.val in ("break",):
                self.adv()
                return True
            if t.val == "goto":
                self.adv()
                self.adv()
                return True
            raise LuaParseError("unexpected keyword %r" % t.val)
        if self.is_op("::"):
            self.adv()
            self.adv()
            self.adv()
            return True
        # expression statement: assignment or call
        a = self.t.start
        targets = [self.suffixedexp(lvalue=True)]
        while self.is_op(","):
            self.adv()
            targets.append(self.suffixedexp(lvalue=True))
        if self.is_op("="):
            self.adv()
            vals = self.explist()
            for k, tgt in enumerate(targets):
                self.assign(tgt, vals[k] if k < len(vals) else None, a)
            return True
        # call statement: result already evaluated (hooks run inside suffixedexp)
        return True

    def assign(self, tgt, v, start_offset):
        kind = tgt[0]
        line = self.toks[self.i - 1].line
        if kind == "name":
            self.store(tgt[1], v)
            self.env.assign_log.append((self.path, line, tgt[1]))
        elif kind == "index":
            base, key = tgt[1], tgt[2]
            if isinstance(base, LTable):
                if isinstance(key, Sym):
                    self.warn("table key could not be resolved: [%s]" % key.text, line)
                if v is None and self.env.keep_on_nil:
                    return
                base.set(key, v)
            # assignments into unknown tables are ignored

    # -- expressions -----------------------------------------------------------------------------
    def explist(self):
        vals = [self.expr()]
        while self.is_op(","):
            self.adv()
            vals.append(self.expr())
        return vals

    def expr(self, limit=0):
        a = self.t.start
        if (self.t.kind == "kw" and self.t.val == "not") or (self.t.kind == "op" and
                                                             self.t.val in ("-", "#", "~")):
            op = self.adv().val
            v = self.expr(UNARY_PRI)
            v = self.unop(op, v, a)
        else:
            v = self.simpleexp()
        while True:
            t = self.t
            op = t.val if (t.kind == "op" or (t.kind == "kw" and t.val in ("and", "or"))) else None
            if op not in BINPRI or BINPRI[op][0] <= limit:
                break
            self.adv()
            rhs = self.expr(BINPRI[op][1])
            v = self.binop(op, v, rhs, a)
        return v

    def _sym(self, a):
        return Sym(self.text(a, self.toks[self.i - 1].end).strip())

    def unop(self, op, v, a):
        if op == "-" and is_num(v):
            return -v
        if op == "not" and (v is None or isinstance(v, bool)):
            return not v
        if op == "#" and isinstance(v, LTable):
            return len(v)
        if op == "#" and isinstance(v, str):
            return len(v)
        return self._sym(a)

    def binop(self, op, l, r, a):
        try:
            if op == "and":
                if l is None or l is False:
                    return l
                if isinstance(l, (Sym, Func)):
                    return self._sym(a)
                return r
            if op == "or":
                if isinstance(l, Sym):
                    return self._sym(a)
                if l is None or l is False:
                    return r
                return l
            if op == "..":
                if isinstance(l, (str, int, float)) and isinstance(r, (str, int, float)) and \
                        not isinstance(l, bool) and not isinstance(r, bool):
                    return lua_tostr(l) + lua_tostr(r)
                return self._sym(a)
            if is_num(l) and is_num(r):
                if op == "+":
                    return l + r
                if op == "-":
                    return l - r
                if op == "*":
                    return l * r
                if op == "/":
                    return l / r if r else self._sym(a)
                if op == "//":
                    return l // r if r else self._sym(a)
                if op == "%":
                    return l % r if r else self._sym(a)
                if op == "^":
                    return float(l) ** r
                if op == "<":
                    return l < r
                if op == ">":
                    return l > r
                if op == "<=":
                    return l <= r
                if op == ">=":
                    return l >= r
            if op == "==" and not isinstance(l, Sym) and not isinstance(r, Sym):
                return l == r
            if op == "~=" and not isinstance(l, Sym) and not isinstance(r, Sym):
                return l != r
        except Exception:
            pass
        return self._sym(a)

    def simpleexp(self):
        t = self.t
        if t.kind == "num":
            self.adv()
            return t.val
        if t.kind == "str":
            self.adv()
            return t.val
        if t.kind == "kw":
            if t.val == "nil":
                self.adv()
                return None
            if t.val == "true":
                self.adv()
                return True
            if t.val == "false":
                self.adv()
                return False
            if t.val == "function":
                a, line = t.start, t.line
                self.skip_block()
                return Func(self.text(a, self.toks[self.i - 1].end), line)
        if self.is_op("..."):
            self.adv()
            return Sym("...")
        if self.is_op("{"):
            return self.table()
        return self.suffixedexp()

    def table(self):
        self.expect_op("{")
        t = LTable()
        n = 1
        while not self.is_op("}"):
            if self.t.kind == "eof":
                raise LuaParseError("unterminated table")
            if self.is_op("["):
                self.adv()
                k = self.expr()
                self.expect_op("]")
                self.expect_op("=")
                v = self.expr()
                if isinstance(k, Sym):
                    self.warn("table key could not be resolved: [%s]" % k.text)
                if k is None:
                    self.warn("nil table key (Lua runtime error 'table index is nil')")
                else:
                    if k in t and not isinstance(k, Sym):
                        self.warn("duplicate key [%r] in table constructor (last wins)" % (k,))
                    t.set(k, v)
            elif self.t.kind == "name" and self.is_op("=", self.peek()):
                k = self.adv().val
                self.adv()
                v = self.expr()
                if k in t:
                    self.warn("duplicate field %r in table constructor (last wins)" % k)
                t.set(k, v)
            else:
                v = self.expr()
                if v is not None:
                    t.h[n] = v
                n += 1
            if self.is_op(",") or self.is_op(";"):
                self.adv()
            elif not self.is_op("}"):
                raise LuaParseError("expected , or } in table at %r" % (self.t.val,))
        self.adv()
        return t

    def primaryexp(self):
        t = self.t
        if t.kind == "name":
            self.adv()
            return ("name", t.val), self.lookup(t.val)
        if self.is_op("("):
            self.adv()
            v = self.expr()
            self.expect_op(")")
            return ("paren",), v
        raise LuaParseError("unexpected %r" % (t.val,))

    def args(self):
        if self.t.kind == "str":
            return [self.adv().val]
        if self.is_op("{"):
            return [self.table()]
        self.expect_op("(")
        vals = []
        if not self.is_op(")"):
            vals = self.explist()
        self.expect_op(")")
        return vals

    def suffixedexp(self, lvalue=False):
        a = self.t.start
        ref, v = self.primaryexp()
        path = ref[1] if ref[0] == "name" else None
        while True:
            if self.is_op("."):
                self.adv()
                name = self.adv().val
                ref = ("index", v, name)
                path = path + "." + name if path else None
                v = self._index(v, name, a)
            elif self.is_op("["):
                self.adv()
                k = self.expr()
                self.expect_op("]")
                ref = ("index", v, k)
                path = None
                v = self._index(v, k, a)
            elif self.is_op(":"):
                self.adv()
                self.adv()
                self.args()
                ref = ("call",)
                path = None
                v = self._sym(a)
            elif self.is_op("(") or self.t.kind == "str" or self.is_op("{"):
                args = self.args()
                ref = ("call",)
                v = self.call(path, v, args, a)
                path = None
            else:
                break
        if lvalue:
            return ref
        return v

    def _index(self, base, key, a):
        if isinstance(base, LTable):
            if isinstance(key, Sym):
                return self._sym(a)
            r = base.get(key)
            if r is None:
                return Sym(self.text(a, self.toks[self.i - 1].end).strip(), missing=True)
            return r
        if isinstance(base, str) and key in ("format", "len", "lower", "upper", "sub"):
            return self._sym(a)
        return self._sym(a)

    def call(self, path, fn, args, a):
        if path in self.env.call_hooks:
            r = self.env.call_hooks[path](self, args)
            if r is not None:
                return r
        if path == "table.deepcopy" and args and isinstance(args[0], LTable):
            return copy.deepcopy(args[0])
        if path == "table.deepcopy" and args and isinstance(args[0], Sym):
            self.warn("table.deepcopy of unresolved value %s" % args[0].text)
        if path == "table.insert" and len(args) >= 2 and isinstance(args[0], LTable):
            t = args[0]
            t.h[len(t) + 1] = args[-1]
            return None
        if path == "setmetatable" and args:
            return args[0]
        return self._sym(a)


def lua_tostr(v):
    if isinstance(v, float) and v.is_integer():
        return str(int(v))
    return str(v)


def fmt_val(v, maxlen=None):
    """Human readable rendering of an evaluated Lua value."""
    if v is None:
        s = "nil"
    elif isinstance(v, bool):
        s = "true" if v else "false"
    elif isinstance(v, float):
        s = lua_tostr(round(v, 4))
    elif isinstance(v, int):
        s = str(v)
    elif isinstance(v, str):
        s = v
    elif isinstance(v, Sym):
        s = v.text
    elif isinstance(v, Func):
        s = "function (line %d)" % v.line
    elif isinstance(v, LTable):
        parts = []
        arr = v.arr()
        for x in arr:
            parts.append(fmt_val(x))
        for k, x in v.items():
            if isinstance(k, int) and 1 <= k <= len(arr):
                continue
            kk = k[1] if isinstance(k, tuple) else k
            parts.append("%s=%s" % (kk, fmt_val(x)))
        s = "{" + ", ".join(parts) + "}"
    else:
        s = str(v)
    if maxlen and len(s) > maxlen:
        s = s[:maxlen - 1] + "…"
    return s


def sym_suffix(v):
    """ELEMENT_FIRE -> FIRE ; POKEMON_ABILITIES.ROCK_SMASH -> ROCK_SMASH."""
    if isinstance(v, Sym):
        t = v.text
        if "." in t:
            return t.rsplit(".", 1)[1]
        return t
    return fmt_val(v)


def lua_eval_expr(text):
    """Evaluate a single Lua expression in an empty environment."""
    it = LuaInterp(LuaEnv(), "return " + text, "<expr>")
    it.adv()
    return it.expr()


# ---------------------------------------------------------------------------------------------
# Markdown helpers
# ---------------------------------------------------------------------------------------------

def md_escape(s):
    s = "" if s is None else str(s)
    s = s.replace("\r", " ").replace("\n", " ").replace("|", "\\|")
    return s.strip()


def md_table(headers, rows):
    out = ["| " + " | ".join(headers) + " |", "|" + "|".join(["---"] * len(headers)) + "|"]
    for r in rows:
        out.append("| " + " | ".join(md_escape(c) for c in r) + " |")
    return "\n".join(out)


def slug(title):
    s = title.strip().lower()
    s = re.sub(r"[^\w\- ]", "", s, flags=re.U)
    return s.replace(" ", "-")


class Doc(object):
    def __init__(self, filename, title, commit):
        self.filename = filename
        self.title = title
        self.commit = commit
        self.summary = []
        self.notes = []
        self.sections = []  # (level, title, body)

    def section(self, title, body, level=2):
        self.sections.append((level, title, body))

    def render(self):
        out = ["<!-- Generated by tools/gen_reference.py from source at commit %s. "
               "Do not edit by hand; regenerate with `python3 tools/gen_reference.py`. -->"
               % self.commit,
               "",
               "# %s" % self.title,
               "",
               "> Generated by `tools/gen_reference.py` from the source tree at commit `%s`. "
               "Regenerate with `python3 tools/gen_reference.py`. Every row below was parsed "
               "from the files named in the *Source* columns; nothing was added by hand."
               % self.commit,
               ""]
        if self.summary:
            out.append("## Summary")
            out.append("")
            out.extend(self.summary)
            out.append("")
        if self.notes:
            out.append("## Parsing notes")
            out.append("")
            out.extend("- " + n for n in self.notes)
            out.append("")
        out.append("## Contents")
        out.append("")
        for level, title, _ in self.sections:
            out.append("%s- [%s](#%s)" % ("  " * (level - 2), title, slug(title)))
        out.append("")
        for level, title, body in self.sections:
            out.append("#" * level + " " + title)
            out.append("")
            if body:
                out.append(body.rstrip())
                out.append("")
        return "\n".join(out).rstrip() + "\n"

    def write(self):
        os.makedirs(OUTDIR, exist_ok=True)
        path = os.path.join(OUTDIR, self.filename)
        with open(path, "w", encoding="utf-8") as f:
            f.write(self.render())
        return path


# ---------------------------------------------------------------------------------------------
# Generic source index (comment-stripped) used for "who uses X" questions
# ---------------------------------------------------------------------------------------------

class SourceIndex(object):
    def __init__(self):
        self.files = OrderedDict()  # relpath -> comment-stripped text

    def build(self):
        roots = [(SRC, (".cpp", ".h")), (DATA, (".lua", ".xml"))]
        for base, exts in roots:
            for dp, dns, fns in os.walk(base):
                dns.sort()
                for fn in sorted(fns):
                    if not fn.endswith(exts):
                        continue
                    p = os.path.join(dp, fn)
                    if fn.startswith("tmpCitizen_"):
                        continue
                    if os.path.getsize(p) > 4 * 1024 * 1024:
                        continue  # map spawn/house dumps
                    txt = read(p)
                    if fn.endswith(".lua"):
                        txt = strip_lua_comments(txt)
                    elif fn.endswith(".xml"):
                        txt = strip_xml_comments(txt)
                    else:
                        txt = strip_c_comments(txt)
                    self.files[rel(p)] = txt
        return self

    def active(self):
        for k, v in self.files.items():
            if not is_historical(os.path.join(ROOT, k)):
                yield k, v

    def grep(self, pattern, active_only=True, exclude=()):
        rx = re.compile(pattern)
        hits = []
        it = self.active() if active_only else self.files.items()
        for k, v in it:
            if k in exclude:
                continue
            for m in rx.finditer(v):
                line = v.count("\n", 0, m.start()) + 1
                hits.append((k, line, m))
        return hits


_INDEX = None


def source_index():
    global _INDEX
    if _INDEX is None:
        _INDEX = SourceIndex().build()
    return _INDEX


def fmt_hits(hits, limit=6):
    seen = OrderedDict()
    for f, line, _ in hits:
        seen.setdefault(f, []).append(line)
    parts = []
    for f, lines in list(seen.items())[:limit]:
        parts.append("`%s:%s`" % (short_path(f), ",".join(str(x) for x in sorted(set(lines))[:3])))
    if len(seen) > limit:
        parts.append("+%d files" % (len(seen) - limit))
    return ", ".join(parts)


def short_path(p):
    for pre in ("server/data/", "server/"):
        if p.startswith(pre):
            return p[len(pre):]
    return p


def code(s):
    return "`%s`" % str(s).replace("`", "'") if s not in (None, "") else ""


# ---------------------------------------------------------------------------------------------
# Shared loaders
# ---------------------------------------------------------------------------------------------

ATTR_RX = re.compile(r'([A-Za-z_][\w\-]*)\s*=\s*"([^"]*)"')


def xml_tags(text, tag):
    """Yield (attrs, offset) for every <tag ...> in text (comments must be stripped first)."""
    for m in re.finditer(r"<%s\b([^>]*)>" % re.escape(tag), text):
        yield OrderedDict(ATTR_RX.findall(m.group(1))), m.start()


def xml_commented_tags(text, tag):
    """Yield (attrs, line) for every <tag ...> that is inside an XML comment."""
    for cm in re.finditer(r"<!--(.*?)-->", text, flags=re.S):
        for m in re.finditer(r"<%s\b([^>]*)>" % re.escape(tag), cm.group(1)):
            line = text.count("\n", 0, cm.start(1) + m.start()) + 1
            yield OrderedDict(ATTR_RX.findall(m.group(1))), line


def parse_int_vec(s):
    """TFS parseIntegerVec: '1-3;7' -> [1,2,3,7]."""
    out = []
    for part in (s or "").split(";"):
        part = part.strip()
        if not part:
            continue
        bits = part.split("-")
        try:
            a = int(bits[0])
        except ValueError:
            continue
        out.append(a)
        if len(bits) > 1:
            try:
                b = int(bits[1])
            except ValueError:
                continue
            while a < b:
                a += 1
                out.append(a)
    return out


def compress_ids(ids):
    ids = sorted(set(ids))
    out = []
    i = 0
    while i < len(ids):
        j = i
        while j + 1 < len(ids) and ids[j + 1] == ids[j] + 1:
            j += 1
        out.append(str(ids[i]) if i == j else "%d-%d" % (ids[i], ids[j]))
        i = j + 1
    return ", ".join(out)


_ITEMS = None


def load_items():
    """items.xml -> {id: {'name', 'article', 'attrs': {key: value}, 'line'}}."""
    global _ITEMS
    if _ITEMS is not None:
        return _ITEMS
    path = os.path.join(DATA, "items", "items.xml")
    text = strip_xml_comments(read(path))
    items = OrderedDict()
    for m in re.finditer(r"<item\b([^>]*?)(/>|>(.*?)</item>)", text, flags=re.S):
        attrs = dict(ATTR_RX.findall(m.group(1)))
        body = m.group(3) or ""
        sub = OrderedDict()
        for k, v in re.findall(r'<attribute\s+key="([^"]*)"\s+value="([^"]*)"', body):
            sub[k] = v
        line = text.count("\n", 0, m.start()) + 1
        ids = []
        if "id" in attrs:
            ids = parse_int_vec(attrs["id"])
        elif "fromid" in attrs and "toid" in attrs:
            try:
                ids = list(range(int(attrs["fromid"]), int(attrs["toid"]) + 1))
            except ValueError:
                ids = []
        for i in ids:
            items[i] = {"name": attrs.get("name", ""), "article": attrs.get("article", ""),
                        "attrs": sub, "line": line, "dup": i in items}
    _ITEMS = items
    return items


def item_name(i):
    it = load_items().get(i)
    return it["name"] if it else None


_EVENTS = None


def load_item_events():
    """actions.xml / movements.xml -> {itemid: [(kind, script, xmlfile)]} plus registration order."""
    global _EVENTS
    if _EVENTS is not None:
        return _EVENTS
    out = defaultdict(list)
    dups = []
    for sub, tag_names, base in (("actions", ("action",), "actions/scripts/"),
                                 ("movements", ("movevent", "movement"), "movements/scripts/")):
        path = os.path.join(DATA, sub, sub + ".xml")
        text = strip_xml_comments(read(path))
        seen = {}
        for tag in tag_names:
            for attrs, off in xml_tags(text, tag):
                line = text.count("\n", 0, off) + 1
                ids = parse_int_vec(attrs.get("itemid", ""))
                if "fromid" in attrs and "toid" in attrs:
                    fr = parse_int_vec(attrs["fromid"].replace("-", ""))
                    to = parse_int_vec(attrs["toid"].replace("-", ""))
                    for a, b in zip(fr, to):
                        ids.extend(range(a, b + 1))
                kind = sub[:-1] if sub == "actions" else "move:" + attrs.get("type", "?")
                script = attrs.get("value", "")
                if attrs.get("event") == "script":
                    sp = os.path.normpath(os.path.join(DATA, sub, "scripts", script))
                    script_rel = rel(sp)
                    exists = os.path.isfile(sp)
                else:
                    script_rel, exists = "function:" + script, True
                for i in ids:
                    key = (kind, i)
                    if key in seen and sub == "actions":
                        dups.append((i, seen[key], "%s:%d" % (rel(path), line)))
                    seen.setdefault(key, "%s:%d" % (rel(path), line))
                    out[i].append((kind, script_rel, exists, "%s:%d" % (sub + ".xml", line)))
    _EVENTS = (out, dups)
    return _EVENTS


def item_events_str(i, limit=3):
    ev, _ = load_item_events()
    parts = []
    for kind, script, exists, where in ev.get(i, [])[:limit]:
        name = short_path(script).replace("lib/ps/events/", "")
        parts.append("%s %s%s" % ("action" if kind == "action" else kind.split(":")[1],
                                  code(name), "" if exists else " (MISSING)"))
    return "; ".join(parts)


def load_groups():
    path = os.path.join(DATA, "XML", "groups.xml")
    text = strip_xml_comments(read(path))
    groups = []
    for attrs, _ in xml_tags(text, "group"):
        groups.append((int(attrs.get("id", 0)), attrs.get("name", ""), int(attrs.get("access", 0))))
    return groups


ACCESS_NAMES = {0: "Player", 1: "Tutor", 2: "Senior Tutor", 3: "Gamemaster",
                4: "Community Manager", 5: "God"}


def load_constants_env():
    env = LuaEnv()
    env.run_file(os.path.join(PSLIB, "others", "constants.lua"))
    return env


def lua_global_defs(prefix):
    """Names NAME defined as `NAME = ...` (top-level) anywhere in the active Lua tree."""
    names = set()
    rx = re.compile(r"^\s*(%s\w*)\s*=" % re.escape(prefix), re.M)
    for f, txt in source_index().active():
        if f.endswith(".lua"):
            names.update(rx.findall(txt))
    return names


def monsters_index():
    path = os.path.join(DATA, "monster", "monsters.xml")
    raw = read(path)
    text = strip_xml_comments(raw)
    mons = OrderedDict()
    for attrs, off in xml_tags(text, "monster"):
        nm = attrs.get("name", "")
        f = attrs.get("file", "")
        fp = os.path.join(DATA, "monster", f)
        info = {"file": f, "exists": os.path.isfile(fp), "min": None, "max": None,
                "dup": nm.lower() in mons}
        if info["exists"]:
            head = read(fp)[:2000]
            m = re.search(r"<monster\b([^>]*)>", head)
            if m:
                a = dict(ATTR_RX.findall(m.group(1)))
                info["min"], info["max"] = a.get("minLevel"), a.get("maxLevel")
                info["xmlname"] = a.get("name")
        mons.setdefault(nm.lower(), info)
    commented = [a.get("name") for a, _ in xml_commented_tags(raw, "monster")]
    return mons, commented


def client_talk_commands():
    """Commands the client sends with g_game.talk*: [(literal, module, file, line, loaded)]."""
    mods = os.path.join(CLIENT, "modules")
    otmods = {}
    loaded_by_list = set()
    for dp, dns, fns in os.walk(mods):
        for fn in fns:
            if fn.endswith(".otmod"):
                t = read(os.path.join(dp, fn))
                m = re.search(r"^\s*name:\s*(\S+)", t, re.M)
                if m:
                    otmods[m.group(1)] = t
                in_list = False
                for ln in t.splitlines():
                    if re.match(r"^\s*load-later:\s*$", ln):
                        in_list = True
                        continue
                    m2 = re.match(r"^\s+-\s*(\S+)\s*$", ln)
                    if in_list and m2:
                        loaded_by_list.add(m2.group(1))
                    else:
                        in_list = False
    ensure = set()
    for dp, dns, fns in os.walk(CLIENT):
        for fn in fns:
            if fn.endswith(".lua"):
                for m in re.findall(r"ensureModuleLoaded\(\s*['\"]([\w]+)['\"]",
                                    read(os.path.join(dp, fn))):
                    ensure.add(m)

    def loaded(mod):
        t = otmods.get(mod, "")
        return bool(re.search(r"autoload:\s*true", t)) or mod in loaded_by_list or mod in ensure

    out = []
    rx = re.compile(r"g_game\.talk(?:Channel|Private)?\s*\(([^\n]*)")
    for dp, dns, fns in os.walk(mods):
        dns.sort()
        for fn in sorted(fns):
            if not fn.endswith(".lua"):
                continue
            p = os.path.join(dp, fn)
            txt = strip_lua_comments(read(p))
            mod = os.path.relpath(p, mods).split(os.sep)[0]
            for m in rx.finditer(txt):
                args = m.group(1)
                lm = re.search(r"'([^']*)'|\"([^\"]*)\"", args)
                if not lm:
                    continue
                lit = lm.group(1) if lm.group(1) is not None else lm.group(2)
                concat = bool(re.match(r"\s*\.\.", args[lm.end():]))
                line = txt.count("\n", 0, m.start()) + 1
                out.append((lit, concat, mod, rel(p), line, loaded(mod)))
    return out


# ---------------------------------------------------------------------------------------------
# COMMANDS.md
# ---------------------------------------------------------------------------------------------

# Words exercised on the running server in docs/PHASE_2_TEST_MATRIX.md (test ids cited).
VERIFIED_COMMANDS = {
    "/held": "P2-14, P2-17",
    "/addon": "P2-14, P2-22 (outfit window sent; choice not exercised)",
    "/boss": "P2-14",
    "/autoloot": "P2-14 (toggle), P2-24 FAIL (OFF not persisted)",
    "/time": "P2-14",
    "/afk": "P2-14",
    "/dv": "P2-14 (no-Pokémon reply only)",
    "/find": "P2-14 (no-Pokémon reply only)",
    "/lang": "P2-14",
    "/cupom": "P2-14 (unknown-code path only)",
    "/list": "P2-14 (not-in-guild path only)",
    "/tvlist": "P2-14 (no-channel path only)",
    "/exp": "P2-05, P2-15",
    "/up": "P2-20, P2-21",
    "/down": "P2-21",
    "/i": "P2-11, P2-12, P2-19",
    "/goto": "P2-32",
    "/send": "P2-02",
    "/m": "P2-05, P2-13",
    "/mypokemon": "P2-11",
    "/cp": "P2-04",
    "/tc": "P2-16",
    "m1": "P2-06", "m2": "P2-06", "m3": "P2-06", "m4": "P2-06", "m5": "P2-06", "m6": "P2-06",
}
# Mentioned in the matrix but without an observed reply, so NOT counted as verified.
EXERCISED_NO_REPLY = {"/help": "P2-14: sent, no reply observed"}

# Known defects from docs/BUG_TRIAGE.md. breaks=True -> status BROKEN.
COMMAND_BUGS = {
    "/autoloot": ("BUG-04: OFF state never persisted across logins (verified P2-24)", True),
    "/cupom": ("BUG-54: coupon types other than 0 consume the code without reward", True),
    "/i": ("BUG-12: created items land in the slot-3 backpack hidden by the client", False),
    "/lang": ("Phase-1 A3: overwritten by the login language at every login (harmless)", False),
    "m1": ("BUG-05: GM groups (infinite mana) cannot use moves; works for players", False),
    "/n": ("BUG-38 note: `/n Soya` loads an NPC whose script `loot.lua` is missing", False),
    "/tvbanlist": ("Phase-1 report: script `tv/banlist.lua` missing (entry commented)", True),
}

POKEMON_SCRIPTS = {"pokemonAddon", "dexView", "pokemonExperience", "heldExperience", "turn",
                   "transformMemory", "skill", "teleport", "flyUp", "flyDown", "find",
                   "pokemon", "summon"}

CATEGORY_ORDER = ["Player commands", "Pokémon commands", "Hidden / client commands",
                  "House commands", "Guild commands", "Tutor commands (access 1)",
                  "Senior Tutor commands (access 2)", "Gamemaster commands (access 3)",
                  "Community Manager commands (access 4)", "God / admin commands (access 5)"]
STAFF_CATS = {1: CATEGORY_ORDER[5], 2: CATEGORY_ORDER[6], 3: CATEGORY_ORDER[7],
              4: CATEGORY_ORDER[8], 5: CATEGORY_ORDER[9]}

MSG_FUNCS = r"(?:doPlayerSendTextMessage|doPlayerSendCancel|doCreatureSay|selfSay|" \
            r"doPlayerPopupFYI|doBroadcastMessage|doPlayerSendChannelMessage)"


def first_comment(src):
    for line in src.splitlines()[:8]:
        s = line.strip()
        if s.startswith("--") and not s.startswith("--[["):
            c = s.lstrip("-").strip()
            if len(c) > 3 and not re.match(r"^(local|function|if|end)\b", c):
                return c
        elif s and not s.startswith("--"):
            break
    return None


def script_messages(src, limit=3):
    msgs = []
    clean = strip_lua_comments(src)
    for m in re.finditer(MSG_FUNCS + r"\s*\(([^\n]*)", clean):
        lm = re.search(r"\"((?:[^\"\\]|\\.){4,})\"|'((?:[^'\\]|\\.){4,})'", m.group(1))
        if lm:
            s = lm.group(1) or lm.group(2)
            if s not in msgs:
                msgs.append(s)
        if len(msgs) >= limit:
            break
    return msgs


def analyse_params(src):
    """Heuristic description of how a talkaction script reads `param`."""
    clean = strip_lua_comments(src)
    body = re.sub(r"function\s+onSay\s*\([^)]*\)", "", clean)
    if not re.search(r"\bparam\b", body):
        return "none", ""
    notes = []
    seps = re.findall(r"(?:string\.explode|string\.split|explode)\s*\(\s*param\s*,\s*['\"]([^'\"]+)['\"]",
                      body)
    var = None
    m = re.search(r"(?:local\s+)?(\w+)\s*=\s*(?:string\.explode|string\.split)\s*\(\s*param\s*,", body)
    if m:
        var = m.group(1)
    if seps:
        idx = set()
        if var:
            idx.update(int(x) for x in re.findall(r"\b%s\[(\d+)\]" % re.escape(var), body))
        notes.append("split on %s%s" % (" / ".join(code(s) for s in sorted(set(seps))),
                                        " into %d field(s)" % max(idx) if idx else ""))
    lits = re.findall(r"\bparam\w*\s*==\s*['\"]([^'\"]+)['\"]", body)
    lits += re.findall(r"lower\(\s*param\s*\)\s*==\s*['\"]([^'\"]+)['\"]", body)
    lits += re.findall(r"param:lower\(\)\s*==\s*['\"]([^'\"]+)['\"]", body)
    if lits:
        notes.append("keywords: " + ", ".join(code(x) for x in OrderedDict.fromkeys(lits)))
    if re.search(r"tonumber\(\s*param", body):
        notes.append("numeric")
    required = bool(re.search(r"param\s*==\s*(''|\"\")|not\s+param\b|param\s*~=\s*(''|\"\")", body))
    if required and not notes:
        notes.append("free text (required)")
    elif required:
        notes.append("required")
    if not notes:
        notes.append("free text (optional)")
    ex = ""
    if seps and var:
        n = max([int(x) for x in re.findall(r"\b%s\[(\d+)\]" % re.escape(var), body)] or [1])
        ex = seps[0].join("arg%d" % (k + 1) for k in range(n))
    elif lits:
        ex = lits[0]
    elif re.search(r"tonumber\(\s*param", body):
        ex = "<number>"
    elif required:
        ex = "<text>"
    else:
        ex = "[text]"
    return "; ".join(notes), ex


def build_commands(commit):
    doc = Doc("COMMANDS.md", "Commands (talkactions) reference", commit)
    xml_path = os.path.join(DATA, "talkactions", "talkactions.xml")
    raw = read(xml_path)
    stripped = strip_xml_comments(raw)
    groups = load_groups()
    access_groups = defaultdict(list)
    for gid, name, acc in groups:
        access_groups[acc].append("%s (group %d)" % (name, gid))

    cpp = read(os.path.join(SRC, "talkaction.cpp"))
    cpp_funcs = set(re.findall(r'tmpFunctionName\s*==\s*"(\w+)"', cpp))

    headings = [(m.start(), m.group(1).strip()) for m in re.finditer(r"<!--(.*?)-->", raw, re.S)
                if "<" not in m.group(1) and len(m.group(1).strip()) < 60]

    def heading_at(off):
        h = ""
        for o, t in headings:
            if o < off:
                h = t
        return h

    client_cmds = client_talk_commands()
    client_by_word = defaultdict(list)
    for lit, concat, mod, path, line, loaded in client_cmds:
        w = lit.split(" ")[0].strip().lower()
        if concat and re.match(r"^[a-z]$", w):
            w = w + "<n>"
        client_by_word[w].append((mod, path, line, loaded, lit, concat))

    entries = []
    registered = defaultdict(list)
    for attrs, off in xml_tags(stripped, "talkaction"):
        line = raw.count("\n", 0, off) + 1
        words = [w for w in attrs.get("words", "").split(";") if w]
        access = int(attrs.get("access", 0) or 0)
        event = attrs.get("event", "")
        value = attrs.get("value", "")
        hidden = attrs.get("hidden", attrs.get("hide", "no")).lower() in ("yes", "1", "true")
        logged = attrs.get("log", attrs.get("logged", "no")).lower() in ("yes", "1", "true")
        src_text = ""
        if event == "script":
            sp = os.path.normpath(os.path.join(DATA, "talkactions", "scripts", value))
            exists = os.path.isfile(sp)
            source = rel(sp)
            if exists:
                src_text = read(sp)
        elif event == "function":
            exists = value.lower() in cpp_funcs
            source = "server/src/talkaction.cpp TalkAction::%s" % value
        else:
            exists, source = False, "(event %r)" % event
        desc = attrs.get("description")
        desc_src = "XML description"
        if not desc and src_text:
            desc = first_comment(src_text)
            desc_src = "script comment"
        if not desc and src_text:
            msgs = script_messages(src_text, 2)
            if msgs:
                desc = "Replies: " + " / ".join('"%s"' % x for x in msgs)
                desc_src = "script messages"
        if not desc and event == "function":
            desc = "C++ built-in `TalkAction::%s`" % value
            desc_src = "C++"
        params, ex_arg = ("see C++ function", "") if event == "function" else \
            (analyse_params(src_text) if src_text else ("?", ""))
        e = dict(words=words, access=access, event=event, value=value, hidden=hidden,
                 logged=logged, exists=exists, source=source, desc=desc or "",
                 desc_src=desc_src, params=params, ex_arg=ex_arg, line=line,
                 heading=heading_at(off), filter=attrs.get("filter", ""),
                 case=attrs.get("case-sensitive", ""))
        for w in words:
            registered[w.lower()].append(line)
        # status
        verified = [(w, VERIFIED_COMMANDS[w.lower()]) for w in words if w.lower() in VERIFIED_COMMANDS]
        bugs = [COMMAND_BUGS[w.lower()] for w in words if w.lower() in COMMAND_BUGS]
        if not exists:
            status = "BROKEN"
        elif any(b[1] for b in bugs):
            status = "BROKEN"
        elif verified:
            status = "VERIFIED"
        else:
            status = "IMPLEMENTED / UNVERIFIED"
        evidence = []
        if verified:
            evidence.append("; ".join("%s: %s" % (w, t) for w, t in verified[:3]) +
                            (" …" if len(verified) > 3 else ""))
        for w in words:
            if w.lower() in EXERCISED_NO_REPLY:
                evidence.append("%s: %s" % (w, EXERCISED_NO_REPLY[w.lower()]))
        if not exists:
            evidence.append("script/function not found")
        e["status"] = status
        e["evidence"] = " · ".join(evidence)
        e["bugs"] = " · ".join(b[0] for b in bugs)
        sent = []
        for w in words:
            wl = w.lower()
            keys = [wl]
            if re.match(r"^[a-z]\d+$", wl):
                keys.append(wl[0] + "<n>")
            for k in keys:
                for mod, path, cl, loaded, lit, concat in client_by_word.get(k, []):
                    sent.append("%s%s" % (mod, "" if loaded else " (module not loaded)"))
        e["client"] = ", ".join(OrderedDict.fromkeys(sent))
        base = os.path.splitext(os.path.basename(value))[0]
        if access > 0:
            cat = STAFF_CATS.get(access, "God / admin commands (access 5)")
        elif hidden:
            cat = "Hidden / client commands"
        elif any(w.lower().startswith("/house") for w in words):
            cat = "House commands"
        elif "guild" in e["heading"].lower() or "guild" in value.lower():
            cat = "Guild commands"
        elif base in POKEMON_SCRIPTS or e["heading"].lower() in ("skills", "abilities"):
            cat = "Pokémon commands"
        else:
            cat = "Player commands"
        e["cat"] = cat
        entries.append(e)

    disabled = []
    for attrs, line in xml_commented_tags(raw, "talkaction"):
        value = attrs.get("value", "")
        event = attrs.get("event", "")
        if event == "script":
            sp = os.path.normpath(os.path.join(DATA, "talkactions", "scripts", value))
            ex, src = os.path.isfile(sp), rel(sp)
        else:
            ex, src = value.lower() in cpp_funcs, "C++ TalkAction::%s" % value
        active_dup = [w for w in attrs.get("words", "").split(";") if w.lower() in registered]
        disabled.append((attrs.get("words", ""), attrs.get("access", "0"), event, src, ex, line,
                         active_dup))

    # Rows
    by_cat = OrderedDict((c, []) for c in CATEGORY_ORDER)
    for e in entries:
        by_cat[e["cat"]].append(e)

    counts = defaultdict(int)
    for e in entries:
        counts[e["status"]] += 1
    nwords = sum(len(e["words"]) for e in entries)
    doc.summary.append(md_table(["Metric", "Value"], [
        ["Active `<talkaction>` entries", len(entries)],
        ["Active words (aliases counted separately)", nwords],
        ["VERIFIED entries", counts["VERIFIED"]],
        ["IMPLEMENTED / UNVERIFIED entries", counts["IMPLEMENTED / UNVERIFIED"]],
        ["BROKEN entries", counts["BROKEN"]],
        ["Disabled (commented-out) entries", len(disabled)],
        ["Distinct strings sent by the client UI", len(set(c[0] for c in client_cmds))],
    ]))
    doc.summary.append("")
    doc.summary.append(md_table(["Category", "Entries"],
                                [[c, len(v)] for c, v in by_cat.items()]))
    doc.summary.append("")
    doc.summary.append("Access levels come from `server/data/XML/groups.xml` (`access` attribute; "
                       "groups without it have access 0):")
    doc.summary.append("")
    doc.summary.append(md_table(["Access", "Role", "Groups"],
                                [[a, ACCESS_NAMES.get(a, "?"), ", ".join(access_groups.get(a, []))]
                                 for a in sorted(set(list(ACCESS_NAMES) + list(access_groups)))]))
    doc.notes += [
        "Source: `server/data/talkactions/talkactions.xml`. Script paths are resolved relative "
        "to `server/data/talkactions/scripts/` exactly like TFS 0.3.6 does; `event=\"function\"` "
        "entries are checked against the names accepted by `TalkAction::loadFunction` in "
        "`server/src/talkaction.cpp`.",
        "Words separated by `;` in one entry are aliases of the same script (first word listed "
        "first). TFS 0.3.6 has no Lua API to register talkactions, so the XML is the only "
        "registration point; scripts that run a command programmatically "
        "(`doCreatureExecuteTalkAction`) are listed in their own section.",
        "**Description** is the XML `description` attribute when present, otherwise the first "
        "comment line of the script, otherwise the first messages the script sends (heuristic).",
        "**Parameters** are inferred heuristically from how the script uses `param` "
        "(`string.explode` separators, compared literals, `tonumber`). Treat them as a hint.",
        "**Status**: VERIFIED only for words exercised in `docs/PHASE_2_TEST_MATRIX.md` (test ids "
        "in the Evidence column, hard-coded in the generator); BROKEN when the script/function is "
        "missing or a `docs/BUG_TRIAGE.md` entry says the command misbehaves for its intended "
        "users; everything else is IMPLEMENTED / UNVERIFIED. Disabled entries are never active.",
        "**Client** lists client modules that send the word through `g_game.talk*` "
        "(`client/modules`), with modules that are never loaded marked.",
    ]

    headers = ["Words (aliases)", "Access", "Log", "Description", "Parameters", "Example",
               "Source", "Status", "Evidence / known issues", "Client"]
    for cat, es in by_cat.items():
        rows = []
        for e in es:
            w0 = e["words"][0] if e["words"] else ""
            ex = (w0 + " " + e["ex_arg"]).strip() if e["ex_arg"] else w0
            if e["filter"] == "word-spaced" and not e["ex_arg"]:
                ex = w0
            flags = []
            if e["hidden"]:
                flags.append("hidden")
            if e["case"]:
                flags.append("case-sensitive=%s" % e["case"])
            if e["heading"]:
                flags.append("XML section: %s" % e["heading"])
            access = "%d %s" % (e["access"], ACCESS_NAMES.get(e["access"], ""))
            ev = " · ".join(x for x in (e["evidence"], e["bugs"]) if x)
            rows.append([" ".join(code(w) for w in e["words"]) +
                         (" (%s)" % ", ".join(flags) if flags else ""),
                         access, "yes" if e["logged"] else "no", e["desc"], e["params"],
                         code(ex), "%s%s (xml:%d)" % (code(short_path(e["source"])),
                                                      "" if e["exists"] else " **MISSING**",
                                                      e["line"]),
                         e["status"], ev, e["client"]])
        doc.section(cat, md_table(headers, rows) if rows else "_No entries._")

    # client-sent strings
    rows = []
    unhandled = []
    for lit, concat, mod, path, line, loaded in client_cmds:
        word = lit.split(" ")[0].lower()
        if concat and re.match(r"^[a-z]$", word):
            handled = any(re.match(r"^%s\d+$" % word, w) for w in registered)
            shown = lit + "<n>"
        else:
            handled = word in registered
            shown = lit.strip() + (" <arg>" if concat else "")
        if word in ("hi",):
            handled_txt = "NPC greeting (not a talkaction)"
        else:
            handled_txt = "yes" if handled else "**NO talkaction registered**"
            if not handled:
                unhandled.append(shown)
        rows.append([code(shown), mod, "yes" if loaded else "**no**",
                     "`%s:%d`" % (path, line), handled_txt])
    doc.section("Strings sent by the client UI", (
        "Every `g_game.talk` / `g_game.talkChannel` / `g_game.talkPrivate` call with a string "
        "literal in `client/modules` (comments stripped). `Loaded` = the module is autoloaded, "
        "listed in another module's `load-later`, or passed to `ensureModuleLoaded`.\n\n" +
        md_table(["Text sent", "Module", "Loaded", "Where", "Server talkaction"], rows)))

    # programmatic invocations
    hits = source_index().grep(r"doCreatureExecuteTalkAction\s*\(\s*\w+\s*,\s*\"([^\"]+)\"")
    agg = OrderedDict()
    for f, line, m in hits:
        word = m.group(1).split(" ")[0]
        agg.setdefault(word, []).append((f, line, m.group(1)))
    rows = []
    for word, lst in agg.items():
        rows.append([code(word), len(lst), ", ".join(sorted(set(code(x[2]) for x in lst))[:6]) +
                     (" …" if len(set(x[2] for x in lst)) > 6 else ""),
                     fmt_hits([(x[0], x[1], None) for x in lst]),
                     "yes" if word.lower() in registered else "**NO**"])
    doc.section("Commands executed by server scripts", (
        "Calls to `doCreatureExecuteTalkAction(cid, \"...\")` in the active Lua tree.\n\n" +
        (md_table(["Word", "Calls", "Texts", "Callers", "Registered"], rows) if rows
         else "_None._")))

    # disabled
    rows = [[code(w), a, ev, code(short_path(s)), "yes" if ex else "**missing**", l,
             ", ".join(code(x) for x in dup) or ""]
            for w, a, ev, s, ex, l, dup in disabled]
    doc.section("Disabled (commented out) commands", (
        "These `<talkaction>` elements are inside XML comments in `talkactions.xml` and are "
        "**not registered**. *Active twin* lists words that are nevertheless registered by "
        "another, active entry (so the word still works, through that other script).\n\n" +
        md_table(["Words", "Access", "Event", "Script", "Script exists", "XML line",
                  "Active twin"], rows)))

    # orphans and duplicates
    referenced = set(os.path.normpath(os.path.join(ROOT, e["source"])) for e in entries
                     if e["event"] == "script")
    referenced |= set(os.path.normpath(os.path.join(ROOT, d[3])) for d in disabled)
    orphans = []
    for base in (os.path.join(DATA, "talkactions", "scripts"),
                 os.path.join(PSLIB, "events", "talkactions")):
        for dp, dns, fns in os.walk(base):
            for fn in sorted(fns):
                p = os.path.normpath(os.path.join(dp, fn))
                if fn.endswith(".lua") and p not in referenced:
                    orphans.append(rel(p))
    dupw = [(w, l) for w, l in registered.items() if len(l) > 1]
    body = ("Scripts on disk that no talkaction entry (active or commented) references:\n\n" +
            ("\n".join("- `%s`" % o for o in sorted(orphans)) or "_None._") +
            "\n\nWords registered more than once (TFS keeps the first):\n\n" +
            ("\n".join("- `%s` at XML lines %s" % (w, l) for w, l in dupw) or "_None._"))
    doc.section("Orphan scripts and duplicate words", body)
    stats = {"entries": len(entries), "words": nwords, "disabled": len(disabled),
             "status": dict(counts), "orphans": len(orphans),
             "client_unhandled": len(unhandled)}
    return doc, stats


# ---------------------------------------------------------------------------------------------
# Pokémon / moves data
# ---------------------------------------------------------------------------------------------

_POKE = None


def load_pokemon_data():
    global _POKE
    if _POKE is not None:
        return _POKE
    pdir = os.path.join(PSCONF, "pokemon")
    env = LuaEnv()
    env.g["POKEMON"] = LTable()
    origin = {}
    copies = {}
    files = sorted(f for f in os.listdir(pdir) if f.endswith(".lua"))
    for fn in files:
        p = os.path.join(pdir, fn)
        before = set(env.g["POKEMON"].keys())
        env.run_file(p)
        for k in env.g["POKEMON"].keys():
            if k not in before:
                origin[k] = rel(p)
        for a, b in re.findall(r'POKEMON\["([^"]+)"\]\s*=\s*table\.deepcopy\(\s*POKEMON\["([^"]+)"\]',
                               strip_lua_comments(read(p))):
            copies[a] = b
    pokemon = env.g["POKEMON"]
    # field-name typos: keys used in POKEMON[...].key = ... assignments
    field_uses = defaultdict(list)
    for fn in files:
        p = os.path.join(pdir, fn)
        txt = strip_lua_comments(read(p))
        for m in re.finditer(r'POKEMON\["([^"]+)"\]\.(\w+)\s*=', txt):
            field_uses[m.group(2)].append((rel(p), txt.count("\n", 0, m.start()) + 1, m.group(1)))
        for m in re.finditer(r"^\s{4}(\w+)\s*=", txt, re.M):
            field_uses[m.group(1)].append((rel(p), txt.count("\n", 0, m.start()) + 1, None))
    # numbers
    nenv = LuaEnv()
    it = nenv.run_file(os.path.join(PSCONF, "pokemonsNumbers.lua"))
    numbers = it.locals.get("pokemonsNumbers") or LTable()
    # ITEMS (evolution items) from pokemon.lua
    ienv = LuaEnv()
    ienv.run_file(os.path.join(PSCONF, "pokemon.lua"))
    items = ienv.g.get("ITEMS") if isinstance(ienv.g.get("ITEMS"), LTable) else LTable()
    # constants (abilities, special abilities, elements, TM ids)
    cenv = load_constants_env()
    _POKE = dict(pokemon=pokemon, origin=origin, copies=copies, numbers=numbers, items=items,
                 cenv=cenv, warnings=env.warnings, field_uses=field_uses, files=files)
    return _POKE


_MOVES = None


def load_moves_data():
    global _MOVES
    if _MOVES is not None:
        return _MOVES
    mdir = os.path.join(PSCONF, "moves")
    env = LuaEnv()
    env.g["MOVES"] = LTable()
    origin = {}
    for fn in sorted(os.listdir(mdir)):
        if not fn.endswith(".lua"):
            continue
        p = os.path.join(mdir, fn)
        before = set(env.g["MOVES"].keys())
        env.run_file(p)
        for k in env.g["MOVES"].keys():
            if k not in before:
                origin[k] = rel(p)
    # skill.lua inline SKILLS_CONFIG (normally only a commented example)
    senv = LuaEnv()
    it = senv.run_file(os.path.join(PSCONF, "skill.lua"))
    inline = it.locals.get("SKILLS_CONFIG") or LTable()
    for k, v in inline.items():
        if k not in env.g["MOVES"]:
            env.g["MOVES"].set(k, v)
            origin[k] = rel(os.path.join(PSCONF, "skill.lua"))
    # TMs
    tenv = load_constants_env()
    tit = tenv.run_file(os.path.join(PSLIB, "systems", "018-technicalMachine.lua"))
    tms = tit.locals.get("TMS") or LTable()
    _MOVES = dict(moves=env.g["MOVES"], origin=origin, warnings=env.warnings, tms=tms,
                  tm_ids=tenv.g.get("TM_IDS") or LTable())
    return _MOVES


def pokemon_skills(p):
    sk = p.get("skills")
    out = []
    if isinstance(sk, LTable):
        arr = sk.arr()
        for k in range(0, len(arr), 2):
            nm = arr[k]
            lvl = arr[k + 1] if k + 1 < len(arr) else None
            out.append((fmt_val(nm), lvl))
    return out


def lt_list(v):
    return v.arr() if isinstance(v, LTable) else []


def element_name(v):
    s = sym_suffix(v)
    s = re.sub(r"^ELEMENT_", "", s)
    return s.capitalize() if s.isupper() else s


def nice_const(v):
    s = sym_suffix(v)
    if s.isupper() or "_" in s:
        return s.replace("_", " ").title()
    return s


def evo_text(evo, items):
    if not isinstance(evo, LTable):
        return fmt_val(evo)
    parts = [fmt_val(evo.get("name"))]
    if evo.get("requiredLevel") is not None:
        parts.append("lv %s" % fmt_val(evo.get("requiredLevel")))
    ri = evo.get("requiredItems")
    if isinstance(ri, LTable):
        names = []
        for x in ri.arr():
            if isinstance(x, Sym) and x.text.startswith("ITEMS."):
                key = x.text.split(".", 1)[1]
                iid = items.get(key)
                names.append("%s (%s)" % (key.replace("_", " ").title(), iid if iid else "UNDEFINED"))
            else:
                n = item_name(x) if is_num(x) else None
                names.append("%s%s" % (fmt_val(x), " (%s)" % n if n else ""))
        if names:
            parts.append("+ " + ", ".join(names))
    if evo.get("requiredTime") is not None:
        parts.append("at " + sym_suffix(evo.get("requiredTime")).replace("WORLD_LIGHT_STATE_", ""))
    for k, v in evo.items():
        if k not in ("name", "requiredLevel", "requiredItems", "requiredTime"):
            parts.append("%s=%s" % (k, fmt_val(v, 40)))
    return " ".join(parts)


# ---------------------------------------------------------------------------------------------
# POKEMON.md
# ---------------------------------------------------------------------------------------------

KNOWN_POKEMON_FIELDS = {"pTypes", "dexStorage", "atk", "def", "spAtk", "spDef", "energy", "chance",
                        "portrait", "dexPortrait", "fastcallPortrait", "catchStorage", "evolutions",
                        "description", "skills", "abilities", "eggGroup", "eggId", "eggChance",
                        "specialAbilities", "learnableTms", "eggMoves", "blockTransform",
                        "ignoreBallCounter", "allowedBall", "price"}


def build_pokemon(commit):
    doc = Doc("POKEMON.md", "Pokémon reference", commit)
    d = load_pokemon_data()
    mv = load_moves_data()
    P, items, cenv = d["pokemon"], d["items"], d["cenv"]
    mons, mons_commented = monsters_index()
    abil_const = cenv.g.get("POKEMON_ABILITIES") or LTable()
    abil_values = set(v for v in abil_const.values() if isinstance(v, str))
    evolve_from = {}
    for name, p in P.items():
        for evo in lt_list(p.get("evolutions")):
            if isinstance(evo, LTable) and isinstance(evo.get("name"), str):
                evolve_from.setdefault(evo.get("name"), (name, evo.get("requiredLevel")))

    rows_base, rows_var = [], []
    notes = []
    for name, p in P.items():
        if not isinstance(p, LTable):
            continue
        num = d["numbers"].get(name)
        types = "/".join(element_name(x) for x in lt_list(p.get("pTypes")))
        mon = mons.get(str(name).lower())
        wild = ""
        if mon and mon.get("min") is not None:
            wild = "%s-%s" % (mon["min"], mon["max"])
        ef = evolve_from.get(name)
        evo_from = "%s @ lv %s" % (ef[0], fmt_val(ef[1])) if ef else ""
        evos = "; ".join(evo_text(e, items) for e in lt_list(p.get("evolutions")))
        catch = fmt_val(p.get("chance"))
        if p.get("allowedBall") is not None:
            catch += "; only %s ball" % fmt_val(p.get("allowedBall"))
        if p.get("ignoreBallCounter"):
            catch += "; no ball counter"
        sk = pokemon_skills(p)
        abil = []
        for a in lt_list(p.get("abilities")):
            if isinstance(a, Sym):
                key = a.text.split(".", 1)[-1]
                av = abil_const.get(key)
                abil.append(av if isinstance(av, str) else "%s (UNDEFINED)" % a.text)
            else:
                abil.append(fmt_val(a) + ("" if fmt_val(a) in abil_values else " (unknown name)"))
        spec = ", ".join(sym_suffix(x) for x in lt_list(p.get("specialAbilities")))
        egg = []
        if p.get("eggId") is not None:
            eid = p.get("eggId")
            egg.append("egg %s%s" % (fmt_val(eid), " (%s)" % item_name(eid) if is_num(eid) and
                                     item_name(eid) else ""))
        if p.get("eggChance") is not None:
            egg.append("chance %s" % fmt_val(p.get("eggChance")))
        eg = ", ".join(sym_suffix(x).replace("POKEMON_EGG_GROUP_", "") for x in lt_list(p.get("eggGroup")))
        if eg:
            egg.append("groups " + eg)
        src = short_path(d["origin"].get(name, "?")).replace("lib/ps/config/", "")
        monster = ""
        if mon:
            monster = "yes" if mon["exists"] else "**file missing**"
        else:
            monster = "**no**"
        row = [num if num is not None else "", name, types, wild, evo_from, evos, catch,
               len(sk), ", ".join(abil), spec, "; ".join(egg), src, monster]
        if name in d["copies"]:
            row.insert(2, d["copies"][name])
            rows_var.append(row)
        else:
            rows_base.append(row)

    def sortkey(r):
        return (r[0] if isinstance(r[0], int) else 9999, str(r[1]))
    rows_base.sort(key=sortkey)
    rows_var.sort(key=sortkey)

    # Consistency notes
    cons = []
    names_lower = set(str(n).lower() for n in P.keys())
    no_monster = [n for n in P.keys() if str(n).lower() not in mons]
    if no_monster:
        cons.append("**Config entries without a `monster/monsters.xml` entry (%d):** %s" %
                    (len(no_monster), ", ".join(code(x) for x in sorted(no_monster))))
    missing_files = [(n, m["file"]) for n, m in mons.items() if not m["exists"]]
    if missing_files:
        cons.append("**`monsters.xml` entries whose file does not exist (%d):** %s" %
                    (len(missing_files), ", ".join("%s → `%s`" % (n, f) for n, f in missing_files)))
    pdir_mons = [(n, m) for n, m in mons.items() if m["file"].lower().startswith("pokemons/")]
    no_cfg = [n for n, m in pdir_mons if n not in names_lower]
    if no_cfg:
        cons.append("**`monster/Pokemons/*` monsters without a Pokémon config (%d):** %s" %
                    (len(no_cfg), ", ".join(code(x) for x in sorted(no_cfg))))
    shiny = [n for n in mons if n.startswith("shiny ")]
    shiny_nocfg = [n for n in shiny if n[6:] not in names_lower]
    cons.append("Shiny variants are generated at load time for every string config name "
                "(`config/pokemon.lua:28-45`, energy 200, portraits 0), i.e. %d `Shiny …` "
                "entries; `monsters.xml` declares %d `Shiny …` monsters%s." %
                (len(P.h), len(shiny),
                 ("; %d of them have no base config: %s" %
                  (len(shiny_nocfg), ", ".join(code(x) for x in sorted(shiny_nocfg))))
                 if shiny_nocfg else ""))
    bad_evo = []
    for name, p in P.items():
        for e in lt_list(p.get("evolutions")):
            if isinstance(e, LTable):
                tn = e.get("name")
                if isinstance(tn, str) and tn not in P:
                    bad_evo.append("%s → %s" % (name, tn))
                for x in lt_list(e.get("requiredItems")):
                    if isinstance(x, Sym) and x.text.startswith("ITEMS.") and \
                            items.get(x.text.split(".", 1)[1]) is None:
                        bad_evo.append("%s → %s needs undefined %s" % (name, tn, x.text))
    if bad_evo:
        cons.append("**Evolution targets/items that are not defined (%d):** %s" %
                    (len(bad_evo), "; ".join(bad_evo)))
    bad_abil = []
    for name, p in P.items():
        if name in d["copies"] and p.get("abilities") is P.get(d["copies"][name], LTable()).get("abilities"):
            continue
        for a in lt_list(p.get("abilities")):
            if isinstance(a, str) and a not in abil_values:
                bad_abil.append("%s: `%s`" % (name, a))
            if isinstance(a, Sym) and not isinstance(abil_const.get(a.text.split(".", 1)[-1]), str):
                bad_abil.append("%s: `%s` (undefined constant)" % (name, a.text))
    if bad_abil:
        cons.append("**Field-ability names not in `POKEMON_ABILITIES` (`others/constants.lua`) — "
                    "never matched by the ability code (%d, cf. BUG-30):** %s" %
                    (len(bad_abil), ", ".join(bad_abil)))
    nonum = [n for n in P.keys() if d["numbers"].get(n) is None and n not in d["copies"]]
    if nonum:
        cons.append("**Base species without a number in `config/pokemonsNumbers.lua` (%d; "
                    "`getPokemonNumberByName` returns nil for them):** %s" %
                    (len(nonum), ", ".join(code(x) for x in sorted(nonum))))
    num_nocfg = [n for n in d["numbers"].keys() if n not in P and not
                 (isinstance(n, str) and n.startswith("Shiny ") and n[6:] in P)]
    if num_nocfg:
        cons.append("**`pokemonsNumbers.lua` names without a config (%d):** %s" %
                    (len(num_nocfg), ", ".join(code(x) for x in sorted(num_nocfg))))
    typos = [(k, v) for k, v in d["field_uses"].items() if k not in KNOWN_POKEMON_FIELDS]
    for k, uses in sorted(typos):
        cons.append("Unknown field `%s` (never read by `config/pokemon.lua` getters, typo?) at %s" %
                    (k, ", ".join("`%s:%d`" % (short_path(f), l) for f, l, _ in uses[:6])))
    egg0 = [n for n, p in P.items() if p.get("eggId") == 0 and n not in d["copies"]]
    if egg0:
        cons.append("Base species with `eggId = 0` (%d): %s" % (len(egg0), ", ".join(code(x) for x in egg0)))
    for f, l, msg in d["warnings"]:
        cons.append("Parser warning `%s:%d`: %s" % (short_path(f), l, msg))
    moves = mv["moves"]
    undefined = defaultdict(list)
    for name, p in P.items():
        for sname, _ in pokemon_skills(p):
            if sname not in moves:
                undefined[sname].append(name)
    if undefined:
        cons.append("**Moves in `skills` lists that are not defined in `config/moves/` (%d):** %s" %
                    (len(undefined), "; ".join("%s (%s)" % (code(k), ", ".join(v[:4]) +
                                                            (" …" if len(v) > 4 else ""))
                                               for k, v in sorted(undefined.items()))))
    dex = defaultdict(list)
    for name, p in P.items():
        if name not in d["copies"] and is_num(p.get("dexStorage")):
            dex[p.get("dexStorage")].append(name)
    dupdex = {k: v for k, v in dex.items() if len(v) > 1}
    if dupdex:
        cons.append("Base species sharing a `dexStorage`: %s" %
                    "; ".join("%s: %s" % (k, ", ".join(v)) for k, v in sorted(dupdex.items())))
    if mons_commented:
        cons.append("`monsters.xml` has %d commented-out `<monster>` entries (not loaded)." %
                    len(mons_commented))

    hist = []
    for dpath in (os.path.join(PSCONF, "_pokemon"), os.path.join(PSLIB, "others", "pokemon_backup")):
        n = len([f for f in os.listdir(dpath) if f.endswith(".lua")]) if os.path.isdir(dpath) else 0
        hist.append([code(rel(dpath) + "/"), n])

    doc.summary.append(md_table(["Metric", "Value"], [
        ["Active config files (`server/data/lib/ps/config/pokemon/*.lua`)", len(d["files"])],
        ["`POKEMON[...]` entries defined (species + variants)", len(P.h)],
        ["Base species rows", len(rows_base)],
        ["Variant rows (created with `table.deepcopy`)", len(rows_var)],
        ["Auto-generated shiny names (not listed)", len(P.h)],
        ["`monsters.xml` entries (all kinds)", len(mons)],
        ["Consistency notes", len(cons)],
    ]))
    doc.notes += [
        "Configs are evaluated by the generator's Lua-table interpreter in file-name order "
        "(sorted). The server loads the directory with `dodirectory` in file-system order; no "
        "file depends on another file's entries (no unresolved `table.deepcopy` was reported).",
        "**Wild level** is `minLevel-maxLevel` from the monster XML registered for the same name "
        "in `server/data/monster/monsters.xml`. **Evolves from** is computed from the other "
        "entries' `evolutions` lists (the same logic as `getPokemonEvolveLevel`).",
        "**Catch** is the `chance` field (the divisor used by `functions/ball/empty.lua`; higher "
        "= harder) plus `allowedBall` / `ignoreBallCounter`.",
        "**Moves** counts the `skills` list (name/level pairs). Field abilities come from "
        "`abilities` (names resolved through `POKEMON_ABILITIES`); special abilities are the "
        "passive `specialAbilities` ids.",
    ]
    headers = ["#", "Name", "Types", "Wild level", "Evolves from", "Evolutions", "Catch",
               "Moves", "Field abilities", "Special abilities", "Egg", "File", "Monster XML"]
    doc.section("Species", md_table(headers, rows_base))
    vh = headers[:2] + ["Copy of"] + headers[2:]
    doc.section("Variants (event / Ranger Club / fusion copies)", md_table(vh, rows_var))
    doc.section("Consistency notes", "\n".join("- " + c for c in cons) if cons else "_None._")
    doc.section("Historical (not loaded) trees", (
        "Present on disk, never loaded (`luascript.cpp` loader is non-recursive and nothing "
        "`dofile`s them; see `docs/HISTORICAL_CODE_DIFF.md`):\n\n" +
        md_table(["Directory", "Lua files"], hist)))
    return doc, {"species": len(rows_base), "variants": len(rows_var), "entries": len(P.h),
                 "consistency_notes": len(cons), "no_monster": len(no_monster)}


# ---------------------------------------------------------------------------------------------
# MOVES.md
# ---------------------------------------------------------------------------------------------

KNOWN_MOVE_FIELDS = {"description", "category", "clientIconId", "iconId", "dType", "functionName",
                     "type", "requiredEnergy", "requiredLevel", "damage", "damageType", "effect",
                     "projectile", "backProjectile", "maxDistance", "cooldownTime",
                     "cooldownStorage", "criticalChance", "makeContact", "areaEffect", "areaName",
                     "area", "damageText", "makeJump", "makeSound", "makeHeal", "wildBlock",
                     "makePunch", "makeRecoil", "ignoreEvasion", "ignoreAccuracy", "mimicable",
                     "makeIndirectDamage", "makeSelfdestruct", "sketchable", "wildLevel"}


def build_moves(commit):
    doc = Doc("MOVES.md", "Moves reference", commit)
    mv = load_moves_data()
    d = load_pokemon_data()
    moves, tms = mv["moves"], mv["tms"]
    P = d["pokemon"]
    users = defaultdict(set)
    egg_users = defaultdict(set)
    for name, p in P.items():
        for sname, _ in pokemon_skills(p):
            users[sname].add(name)
        for em in lt_list(p.get("eggMoves")):
            egg_users[fmt_val(em)].add(name)
    tm_moves = {}
    for k, t in tms.items():
        if isinstance(t, LTable):
            tm_moves.setdefault(fmt_val(t.get("move")), []).append(t.get("itemid"))
    rows = []
    icon_dup = defaultdict(list)
    cd_dup = defaultdict(list)
    unknown_fields = defaultdict(list)
    for name in sorted(moves.keys(), key=lambda x: str(x)):
        m = moves.get(name)
        if not isinstance(m, LTable):
            continue
        en = m.get("requiredEnergy")
        eff = int(math.ceil(en * 0.75)) if is_num(en) and en > 0 else en
        area = sym_suffix(m.get("type"))
        if m.get("areaName") is not None:
            area += " (%s)" % fmt_val(m.get("areaName"))
        rng = fmt_val(m.get("maxDistance")) if m.get("maxDistance") is not None else ""
        icon = m.get("clientIconId")
        icon_dup[icon].append(name)
        cd_dup[m.get("cooldownStorage")].append(name)
        for k in m.keys():
            if k not in KNOWN_MOVE_FIELDS:
                unknown_fields[k].append(name)
        tm = ", ".join(str(x) for x in tm_moves.get(name, []))
        rows.append([name, element_name(m.get("damageType")) if m.get("damageType") is not None else "",
                     sym_suffix(m.get("category")), fmt_val(m.get("damage")) if m.get("damage") is not None else "",
                     "%s → %s" % (fmt_val(en), fmt_val(eff)) if en is not None else "",
                     fmt_val(m.get("cooldownTime")) if m.get("cooldownTime") is not None else "**missing**",
                     area, rng, fmt_val(icon), len(users.get(name, ())),
                     len(egg_users.get(name, ())), tm,
                     fmt_val(m.get("requiredLevel")) if m.get("requiredLevel") is not None else "",
                     short_path(mv["origin"].get(name, "")).replace("lib/ps/config/", "")])
    unused = [r[0] for r in rows if r[9] == 0 and r[10] == 0 and not r[11]]
    only_egg_tm = [r[0] for r in rows if r[9] == 0 and (r[10] or r[11])]
    undefined = sorted(n for n in users if n not in moves)
    undefined_egg = sorted(n for n in egg_users if n not in moves)
    undefined_tm = sorted(n for n in tm_moves if n not in moves)

    doc.summary.append(md_table(["Metric", "Value"], [
        ["Moves defined (`MOVES[...]` in `config/moves/*.lua` + inline `SKILLS_CONFIG`)", len(rows)],
        ["Used in at least one `skills` list", sum(1 for r in rows if r[9])],
        ["Only reachable as egg move / TM", len(only_egg_tm)],
        ["Defined but used by no Pokémon (no skills, egg move or TM)", len(unused)],
        ["Referenced in `skills` but not defined", len(undefined)],
        ["Referenced in `eggMoves` but not defined", len(undefined_egg)],
        ["TM moves not defined", len(undefined_tm)],
        ["Historical `others/moves_disabled/*.lua` (not loaded)",
         len([f for f in os.listdir(os.path.join(PSLIB, "others", "moves_disabled"))
              if f.endswith(".lua")]) if os.path.isdir(os.path.join(PSLIB, "others", "moves_disabled")) else 0],
    ]))
    doc.notes += [
        "Source: `server/data/lib/ps/config/moves/*.lua` (loaded by `config/skill.lua` with "
        "`dodirectory`) plus the inline `SKILLS_CONFIG` table of `skill.lua` (only a commented "
        "example today).",
        "**Energy** shows the configured `requiredEnergy` and the effective value after "
        "`skill.lua:75-79` multiplies every positive cost by 0.75 (rounded up).",
        "**Power** is the `damage` field; **Cooldown** is `cooldownTime` in seconds; "
        "**Range** is `maxDistance` (empty = not set); **Area** is the `type` "
        "(`SKILLS_TYPES.TARGET/AREA/STATS`) plus `areaName` when present.",
        "**Users** counts `POKEMON[...]` entries (species and variants, not auto shinies) whose "
        "`skills` list contains the move; **Egg** counts `eggMoves` lists (the server filters "
        "egg moves again at start-up in `doUpdatePokemonEggMovesList`); **TM** lists TM item ids "
        "from `systems/018-technicalMachine.lua`.",
    ]
    headers = ["Move", "Type", "Category", "Power", "Energy (cfg → eff.)", "Cooldown", "Area",
               "Range", "clientIconId", "Users", "Egg", "TM", "Req. level", "File"]
    doc.section("Moves", md_table(headers, rows))
    flags = []
    flags.append("**Defined but used by no Pokémon (%d):** %s" %
                 (len(unused), ", ".join(code(x) for x in unused) or "none"))
    flags.append("**Only as egg move or TM (%d):** %s" %
                 (len(only_egg_tm), ", ".join(code(x) for x in only_egg_tm) or "none"))
    flags.append("**Referenced in `skills` lists but not defined (%d):** %s" %
                 (len(undefined), "; ".join("%s (%s)" % (code(n), ", ".join(sorted(users[n])[:5]))
                                            for n in undefined) or "none"))
    flags.append("**Referenced in `eggMoves` but not defined (%d, removed at start-up by "
                 "`doUpdatePokemonEggMovesList`):** %s" %
                 (len(undefined_egg), ", ".join(code(x) for x in undefined_egg) or "none"))
    flags.append("**TM moves not defined (%d):** %s" %
                 (len(undefined_tm), ", ".join(code(x) for x in undefined_tm) or "none"))
    di = {k: v for k, v in icon_dup.items() if len(v) > 1 and k not in (None, 0)}
    if di:
        flags.append("Shared `clientIconId` values: %s" %
                     "; ".join("%s: %s" % (k, ", ".join(v)) for k, v in sorted(di.items(), key=lambda x: str(x[0]))))
    dc = {k: v for k, v in cd_dup.items() if len(v) > 1}
    if dc:
        flags.append("Shared `cooldownStorage` values (moves share one cooldown): %s" %
                     "; ".join("%s: %s" % (k, ", ".join(v)) for k, v in sorted(dc.items(), key=lambda x: str(x[0]))))
    for k, v in sorted(unknown_fields.items()):
        flags.append("Unknown field `%s` (typo?) in: %s" % (k, ", ".join(code(x) for x in v)))
    if unused:
        refs = []
        for n in unused:
            hits = [h for h in source_index().grep(r'"%s"' % re.escape(n))
                    if h[0] != mv["origin"].get(n)]
            refs.append("%s: %s" % (code(n), fmt_hits(hits) or "no other reference"))
        flags.append("Other references to the unused moves (monster XML / spells / scripts): " +
                     "; ".join(refs))
    for f, l, msg in mv["warnings"]:
        flags.append("Parser warning `%s:%d`: %s" % (short_path(f), l, msg))
    doc.section("Consistency notes", "\n".join("- " + x for x in flags))
    return doc, {"moves": len(rows), "unused": len(unused), "undefined_in_skills": len(undefined),
                 "undefined_egg": len(undefined_egg), "undefined_tm": len(undefined_tm)}


# ---------------------------------------------------------------------------------------------
# NPC data (shared by NPCS, POKEBALLS, QUESTS)
# ---------------------------------------------------------------------------------------------

_NPCS = None


def live_spawn_file():
    """The spawn file named in the OTBM header of the map that config.lua loads."""
    cfg = os.path.join(SERVER, "config.example.lua")
    if not os.path.isfile(cfg):
        cfg = os.path.join(SERVER, "config.lua")
    mapname = "map"
    m = re.search(r'^\s*mapName\s*=\s*"([^"]+)"', strip_lua_comments(read(cfg)), re.M)
    if m:
        mapname = m.group(1)
    otbm = os.path.join(DATA, "world", mapname + ".otbm")
    spawn, house, how = None, None, ""
    if os.path.isfile(otbm):
        with open(otbm, "rb") as f:
            head = f.read(8192)
        strs = [s.decode("latin-1") for s in re.findall(rb"[\x20-\x7e]{4,}", head)]
        for s in strs:
            if s.endswith("spawn.xml") and spawn is None:
                spawn = s
            if s.endswith("house.xml") and house is None:
                house = s
        how = "OTBM header of `server/data/world/%s.otbm` (OTBM_ATTR_EXT_SPAWN_FILE, read by " \
              "`server/src/iomap.cpp:188-197`)" % mapname
    if not spawn:
        spawn = mapname + "-spawn.xml"
        how = "fallback `<mapName>-spawn.xml`"
    return rel(cfg), mapname, spawn, house, how


def parse_spawns(path):
    """-> {npc name: [(x,y,z)]}, monster count."""
    out = defaultdict(list)
    nmon = 0
    if not os.path.isfile(path):
        return out, 0
    text = strip_xml_comments(read(path))
    for sm in re.finditer(r"<spawn\b([^>]*)>(.*?)</spawn>", text, flags=re.S):
        a = dict(ATTR_RX.findall(sm.group(1)))
        try:
            cx, cy, cz = int(a.get("centerx", 0)), int(a.get("centery", 0)), int(a.get("centerz", 0))
        except ValueError:
            continue
        for attrs, _ in xml_tags(sm.group(2), "npc"):
            try:
                x = cx + int(attrs.get("x", 0))
                y = cy + int(attrs.get("y", 0))
                z = int(attrs["z"]) if "z" in attrs else cz
            except ValueError:
                continue
            out[attrs.get("name", "")].append((x, y, z))
        nmon += len(re.findall(r"<monster\b", sm.group(2)))
    return out, nmon


def parse_shop(value):
    out = []
    for part in value.split(";"):
        bits = [b.strip() for b in part.strip().split(",")]
        if len(bits) >= 3:
            try:
                out.append((bits[0], int(bits[1]), int(bits[2])))
            except ValueError:
                continue
    return out


def load_npcs():
    global _NPCS
    if _NPCS is not None:
        return _NPCS
    ndir = os.path.join(DATA, "npc")
    npcs = OrderedDict()
    tmp = []
    for fn in sorted(os.listdir(ndir)):
        if not fn.endswith(".xml"):
            continue
        if fn.startswith("tmpCitizen_"):
            tmp.append(fn)
            continue
        p = os.path.join(ndir, fn)
        text = strip_xml_comments(read(p))
        m = re.search(r"<npc\b([^>]*)>", text)
        a = dict(ATTR_RX.findall(m.group(1))) if m else {}
        params = OrderedDict()
        for pm in re.finditer(r'<parameter\s+key="([^"]*)"\s+value="([^"]*)"', text, flags=re.S):
            params[pm.group(1)] = pm.group(2)
        script = a.get("script", "")
        sp = os.path.join(ndir, "scripts", script) if script else None
        npcs[fn[:-4]] = dict(file=rel(p), name=a.get("name", ""), script=script,
                             script_exists=bool(sp and os.path.isfile(sp)), params=params,
                             buy=parse_shop(params.get("shop_buyable", "")),
                             sell=parse_shop(params.get("shop_sellable", "")))
    cfg, mapname, spawn, house, how = live_spawn_file()
    live, nmon_live = parse_spawns(os.path.join(DATA, "world", spawn))
    others = OrderedDict()
    for fn in sorted(os.listdir(os.path.join(DATA, "world"))):
        if fn.endswith("spawn.xml") and fn != spawn:
            others[fn] = parse_spawns(os.path.join(DATA, "world", fn))[0]
    dyn = defaultdict(list)
    for f, line, m in source_index().grep(r"doCreateNpc\s*\(\s*\"([^\"]+)\""):
        dyn[m.group(1)].append((f, line))
    for f, line, m in source_index().grep(r"\{\s*\"([^\"]+)\"\s*,\s*\{\s*x\s*=", exclude=()):
        if f.endswith("globalevents/scripts/start.lua"):
            dyn[m.group(1)].append((f, line))
    for f, line, m in source_index().grep(r"doCreateNpc\s*\(\s*table\.random\(\s*\{([^}]*)\}"):
        for nm in re.findall(r"\"([^\"]+)\"", m.group(1)):
            dyn[nm].append((f, line))
    _NPCS = dict(npcs=npcs, tmp=tmp, cfg=cfg, mapname=mapname, spawn=spawn, house=house, how=how,
                 live=live, others=others, dyn=dyn, nmon_live=nmon_live)
    return _NPCS


GYM_LEADERS = {"brock", "misty", "ltsurge", "erika", "koga", "sabrina", "blaine", "giovanni"}
ELITE_FOUR = {"lorelei", "bruno", "agatha", "lance", "elitefourchampion"}
ROLE_RULES = [
    (r"^npcbattle_fi_", "Frontier Island trainer"),
    (r"^npcbattle_rocket", "Team Rocket battle"),
    (r"^npcbattle_substitute", "substitute battle"),
    (r"^npcbattle_", "trainer battle"),
    (r"^quest_|^tutorial_quests", "quest"),
    (r"^mastery_", "mastery (clan)"),
    (r"^event_", "seasonal event"),
    (r"^shop_", "shop"),
    (r"^bank", "bank"),
    (r"^nurse", "nurse (Pokémon Center)"),
    (r"^guide", "town guide"),
    (r"^travels?", "travel / boat"),
    (r"^daycare", "daycare"),
    (r"^tournament", "tournament"),
    (r"^soulTrade", "Soul Trade (nicknames, guilds)"),
    (r"^poketrader", "PokeTrader auction"),
    (r"^market", "item market"),
    (r"^saffariZone", "Safari Zone"),
    (r"^rangerClub", "Ranger Club"),
    (r"^professor", "starter professor"),
    (r"^elitefour", "Elite Four entrance"),
    (r"^fi_|^wavearena", "Frontier Island"),
    (r"^testserver_", "test-server tool"),
    (r"^environment_", "scenery / quest prop"),
    (r"^eggmove_|^held_remove|^tm_remover|^sketch_reset|^vitamin_reset", "Pokémon service"),
    (r"^casino", "casino"),
    (r"^gameplayTutorial", "tutorial shop"),
    (r"^ashKetchum", "special dialogue"),
    (r"^battleNpc", "generic battle"),
    (r"^default", "generic dialogue"),
]


def npc_role(script, params):
    base = os.path.splitext(os.path.basename(script))[0]
    low = base.lower()
    if low.startswith("npcbattle_"):
        who = low[len("npcbattle_"):]
        if who in GYM_LEADERS:
            return "gym leader"
        if who in ELITE_FOUR:
            return "Elite Four"
    for rx, role in ROLE_RULES:
        if re.search(rx, base):
            if role == "generic dialogue" and (params.get("shop_buyable") or params.get("shop_sellable")):
                return "shop (generic script)"
            return role
    return base or "(no script)"


# ---------------------------------------------------------------------------------------------
# POKEBALLS.md
# ---------------------------------------------------------------------------------------------

def build_pokeballs(commit):
    doc = Doc("POKEBALLS.md", "Poké Balls reference", commit)
    env = LuaEnv()
    path = os.path.join(PSCONF, "balls.lua")
    it = env.run_file(path)
    balls = env.g.get("balls") or LTable()
    catch = it.locals.get("CATCH_RATE") or LTable()
    effects_def = lua_global_defs("EFFECT_")
    proj_def = lua_global_defs("PROJECTILE_")
    npcs = load_npcs()
    sold = defaultdict(list)
    bought = defaultdict(list)
    for key, n in npcs["npcs"].items():
        live = "live" if n["name"] in npcs["live"] else ("dynamic" if n["name"] in npcs["dyn"] else "not spawned")
        for nm, iid, price in n["buy"]:
            sold[iid].append((price, live, n["name"]))
        for nm, iid, price in n["sell"]:
            bought[iid].append((price, "", n["name"]))

    def shops_str(lst):
        grp = OrderedDict()
        for price, live, name in sorted(lst):
            grp.setdefault((price, live), []).append(name)
        return "; ".join("%d NPC(s) at %s $%s: %s" % (len(v), p, (" (%s)" % l) if l else "",
                                                      ", ".join(v)) for (p, l), v in grp.items())
    ev, _ = load_item_events()
    rows, issues = [], []
    for name, b in balls.items():
        if not isinstance(b, LTable):
            continue
        ids = OrderedDict((k, b.get(k)) for k in ("empty", "inUse", "charged", "discharged"))
        effs = b.get("effects")
        eff_txt = []
        if isinstance(effs, LTable):
            for k, v in effs.items():
                s = sym_suffix(v)
                ok = s in effects_def
                eff_txt.append("%s=%s%s" % (k, s, "" if ok else " **UNDEFINED**"))
                if not ok:
                    issues.append("`%s` effect `%s` = `%s` is not defined anywhere (nil → effect 0)%s" %
                                  (name, k, s, " — BUG-22" if s == "EFFECT_SILVERBALL_US" else ""))
        else:
            eff_txt.append("(no effects table)")
            issues.append("`%s` has no `effects` table" % name)
        proj = sym_suffix(b.get("projectile"))
        if b.get("projectile") is not None and proj not in proj_def:
            issues.append("`%s` projectile `%s` is not defined" % (name, proj))
        rate = catch.get(name)
        where = []
        for k, iid in ids.items():
            if is_num(iid):
                where += sold.get(iid, [])
        equip_missing = [str(ids[k]) for k in ("inUse", "charged", "discharged")
                         if is_num(ids[k]) and not any(e[0] == "move:Equip" for e in ev.get(ids[k], []))]
        if equip_missing:
            issues.append("`%s` ids %s have no `Equip` movement (`movements.xml` → `ball.lua`)" %
                          (name, ", ".join(equip_missing)))
        names = []
        for k, iid in ids.items():
            if is_num(iid):
                nm = item_name(iid)
                if nm is None:
                    issues.append("`%s` %s id %s is not defined in `items.xml`" % (name, k, iid))
        first = next((iid for iid in ids.values() if is_num(iid)), None)
        rows.append([name] + [fmt_val(v) if v is not None else "" for v in ids.values()] +
                     [(fmt_val(rate) if rate is not None else "1 (default)"),
                      "yes" if b.get("useCounter") else "",
                      proj, ", ".join(eff_txt), item_name(first) or "",
                      shops_str(where)])
    for k in catch.keys():
        if k not in balls:
            issues.append("`CATCH_RATE[%r]` has no matching ball in `balls` (unused multiplier)" % k)
    for f, l, msg in env.warnings:
        issues.append("Parser warning `%s:%d`: %s" % (short_path(f), l, msg))
    # empty balls sold
    empty_ids = [b.get("empty") for _, b in balls.items() if isinstance(b, LTable) and is_num(b.get("empty"))]
    doc.summary.append(md_table(["Metric", "Value"], [
        ["Ball types in `balls` (`config/balls.lua`)", len(rows)],
        ["Types with an empty (throwable) id", len(empty_ids)],
        ["Types with an explicit catch multiplier (`CATCH_RATE`)", len(catch.h)],
        ["Item ids covered", sum(1 for r in rows for v in r[1:5] if v)],
        ["Issues", len(issues)],
    ]))
    doc.notes += [
        "Source: the `balls` table and the local `CATCH_RATE` table of "
        "`server/data/lib/ps/config/balls.lua`; `getBallCatchRate` returns `CATCH_RATE[name] or 1`. "
        "The catch roll itself is in `functions/ball/empty.lua` (Pokémon `chance` divided by "
        "`rateCatch` + extra catch rate, minus catching skill).",
        "Only balls with an `empty` id can be thrown; the others are cosmetic \"paint\" variants a "
        "Pokémon is moved into (ball painter NPC, events).",
        "**Sold by** comes from the `shop_buyable` parameter of NPC XML files (`server/data/npc/*.xml`); "
        "`live` = spawned by the live spawn file, `dynamic` = created by a script, `not spawned` = no "
        "spawn found. Script-driven shops (e.g. ball painting) are not parsed.",
        "Effect/projectile names are checked against every `EFFECT_*` / `PROJECTILE_*` global "
        "assigned in the active Lua tree.",
    ]
    doc.section("Ball types", md_table(["Ball", "Empty", "In use", "Charged", "Discharged",
                                        "Catch ×", "Ball counter", "Projectile", "Effects",
                                        "items.xml name", "Sold by (NPC shop)"], rows))
    rows2 = []
    for iid in empty_ids:
        rows2.append([iid, item_name(iid) or "", shops_str(sold.get(iid, [])) or "—",
                      shops_str(bought.get(iid, [])) or "—", item_events_str(iid)])
    doc.section("Throwable balls: shops and handlers",
                md_table(["Item id", "Name", "Sold by", "Bought by", "Action / movement"], rows2))
    doc.section("Issues", "\n".join("- " + x for x in issues) if issues else "_None._")
    return doc, {"ball_types": len(rows), "throwable": len(empty_ids), "issues": len(issues)}


# ---------------------------------------------------------------------------------------------
# ITEMS.md
# ---------------------------------------------------------------------------------------------

SLOT_ITEMS = OrderedDict([
    (13206, "order icon (inventory slot 1, Pokémon in ball)"),
    (7730, "order icon (inventory slot 1, Pokémon out)"),
    (13204, "evolve icon (slot 2)"),
    (12280, "badge case (slot 5)"),
    (12281, "Pokédex (slot 6)"),
    (12282, "pokebag (slot 10)"),
    (6500, "Soul Coin (premium currency)"),
])


def build_items(commit):
    doc = Doc("ITEMS.md", "Items reference (PSoul-relevant subsets)", commit)
    items = load_items()
    ev, dups = load_item_events()
    cenv = load_constants_env()
    d = load_pokemon_data()
    mv = load_moves_data()

    def row(iid, extra=""):
        nm = item_name(iid)
        return [iid, nm if nm is not None else "**not in items.xml**", extra, item_events_str(iid, 4)]

    headers = ["Id", "items.xml name", "Config", "Action / movement script"]
    sections = []
    # stones / evolution items
    evo_items = OrderedDict()
    for k, v in d["items"].items():
        evo_items[v] = "ITEMS.%s" % k
    for name, p in d["pokemon"].items():
        for e in lt_list(p.get("evolutions")):
            if isinstance(e, LTable):
                for x in lt_list(e.get("requiredItems")):
                    if is_num(x) and x not in evo_items:
                        evo_items[x] = "literal id in %s evolution" % name
    sections.append(("Evolution stones and items", [row(i, t) for i, t in evo_items.items()],
                     "`ITEMS` in `lib/ps/config/pokemon.lua` plus literal ids in `evolutions`."))
    # TMs
    trows = []
    tm_names = {v: k for k, v in (mv["tm_ids"].items() if mv["tm_ids"] else []) if is_num(v)}
    for k, t in sorted(mv["tms"].items(), key=lambda x: x[0] if is_num(x[0]) else 0):
        if isinstance(t, LTable):
            trows.append(row(t.get("itemid"), "TM %s `%s` → %s (lv %s)" % (
                k, tm_names.get(k, "?"), fmt_val(t.get("move")), fmt_val(t.get("requiredLevel")))))
    sections.append(("Technical Machines (TM_IDS)", trows,
                     "`TMS` in `lib/ps/systems/018-technicalMachine.lua`, keys from `TM_IDS` "
                     "(`others/constants.lua`)."))
    # held items
    henv = load_constants_env()
    hit = henv.run_file(os.path.join(PSLIB, "systems", "046-heldItem.lua"))
    helds = hit.locals.get("HELDS") or LTable()
    held_ids = {v: k for k, v in (henv.g.get("HELD_IDS") or LTable()).items()}
    sections.append(("Held items", [row(h.get("itemId"), "%s `%s`: values %s" % (
        fmt_val(h.get("name")), held_ids.get(k, k), fmt_val(h.get("values"))))
        for k, h in helds.items() if isinstance(h, LTable)],
        "`HELDS` in `lib/ps/systems/046-heldItem.lua`."))
    venv = load_constants_env()
    vit = venv.run_file(os.path.join(PSLIB, "systems", "040-vitamin.lua"))
    vits = vit.locals.get("VITAMINS") or LTable()
    sections.append(("Vitamins", [row(v.get("itemId"), "%s: values %s" % (
        fmt_val(v.get("name")), fmt_val(v.get("values"))))
        for k, v in vits.items() if isinstance(v, LTable)],
        "`VITAMINS` in `lib/ps/systems/040-vitamin.lua`."))

    def by_script(rx):
        ids = []
        for iid, lst in ev.items():
            if any(re.search(rx, s) for _, s, _, _ in lst):
                ids.append(iid)
        return sorted(ids)
    sections.append(("Food", [row(i) for i in by_script(r"/actions/food\.lua$|pokemonFood")],
                     "Ids registered to `events/actions/food.lua` / `pokemonFood.lua` in `actions.xml`."))
    pot = by_script(r"/potions/|revive|[Pp]otion")
    sections.append(("Potions and revives", [row(i) for i in pot],
                     "Ids registered to scripts under `events/actions/potions/` or with potion/revive "
                     "in the script name."))
    eggs = OrderedDict()
    for name, p in d["pokemon"].items():
        e = p.get("eggId")
        if is_num(e) and e > 0 and name not in d["copies"]:
            eggs.setdefault(e, []).append(name)
    erows = [row(i, "egg of " + ", ".join(v)) for i, v in sorted(eggs.items())]
    for i in by_script(r"[Ii]ncubator|[Ee]gg"):
        if i not in eggs:
            erows.append(row(i, "egg/incubator handler"))
    sections.append(("Eggs and incubators", erows,
                     "`eggId` of every base species plus ids registered to egg / incubator scripts."))
    sections.append(("Icons, slot items and currency", [row(i, t) for i, t in SLOT_ITEMS.items()],
                     "Fixed ids used by the starting kit (`functions/player.lua doPlayerAddMainItems`, "
                     "`psoul_dev_seed.sql`)."))
    benv = LuaEnv()
    benv.run_file(os.path.join(PSCONF, "balls.lua"))
    brows = []
    for name, b in (benv.g.get("balls") or LTable()).items():
        if isinstance(b, LTable):
            for k in ("empty", "inUse", "charged", "discharged"):
                if is_num(b.get(k)):
                    brows.append(row(b.get(k), "%s ball (%s)" % (name, k)))
    sections.append(("Ball ids", brows, "From `balls` in `lib/ps/config/balls.lua` (see POKEBALLS.md)."))
    sections.append(("Event items", [row(i) for i in by_script(r"/events/(actions|movements)/events/")],
                     "Ids registered to scripts under `lib/ps/events/*/events/` (Easter, Halloween, "
                     "Christmas, anniversary, July vacation)."))

    for title, rows, note in sections:
        doc.section(title, note + "\n\n" + md_table(headers, rows))

    # broken references
    undefined = sorted(i for i in ev if i not in items)
    missing_scripts = sorted(set((s, w) for lst in ev.values() for k, s, ex, w in lst if not ex))
    ids = sorted(items)
    gaps = []
    for a, b in zip(ids, ids[1:]):
        if b - a - 1 > 50:
            gaps.append((a + 1, b - 1, b - a - 1))
    dup_defs = sorted(i for i, it in items.items() if it["dup"])
    # summary
    doc.summary.append(md_table(["Metric", "Value"], [
        ["Item ids defined in `items.xml`", len(items)],
        ["Lowest / highest id", "%s / %s" % (ids[0], ids[-1]) if ids else "-"],
        ["Ids with a non-empty name", sum(1 for it in items.values() if it["name"])],
        ["Ids with an action or movement registered", len(ev)],
        ["Registered ids not defined in `items.xml`", len(undefined)],
        ["Missing action/movement scripts", len(missing_scripts)],
        ["Duplicate action registrations (first wins)", len(dups)],
        ["Free gaps > 50 ids inside the used range", len(gaps)],
    ] + [["Rows in “%s”" % t, len(r)] for t, r, _ in sections]))
    doc.notes += [
        "A full index of every item id would be far too long; this file lists only the PSoul-relevant "
        "subsets that can be detected from configs or from the script an id is registered to.",
        "`items.xml` is read with regular expressions (`id`, `fromid`/`toid` ranges, nested "
        "`<attribute>`), comments stripped. `actions.xml` / `movements.xml` id lists are expanded "
        "exactly like `parseIntegerVec` (`server/src/tools.cpp`).",
        "Category membership by script name is heuristic (e.g. a script name containing "
        "\"potion\").",
    ]
    rng = []
    for a, b, n in gaps:
        rng.append([a, b, n])
    doc.section("ID ranges in use", (
        "Defined ids span **%s–%s**. Gaps of more than 50 consecutive undefined ids inside that "
        "range (candidates for new items; client `.dat` must define the same ids):\n\n" %
        (ids[0], ids[-1]) + md_table(["First free", "Last free", "Size"], rng) +
        "\n\nDensity by thousand (defined ids per block):\n\n" +
        md_table(["Block", "Defined"], [["%d-%d" % (k * 1000, k * 1000 + 999),
                                          sum(1 for i in ids if i // 1000 == k)]
                                         for k in range(ids[0] // 1000, ids[-1] // 1000 + 1)])))
    br = []
    br.append("**Ids registered in actions/movements but not defined in `items.xml` (%d):** %s" %
              (len(undefined), compress_ids(undefined) or "none"))
    br.append("**Missing scripts (%d):** %s" % (len(missing_scripts), "; ".join(
        "`%s` (%s)" % (short_path(s), w) for s, w in missing_scripts) or "none"))
    br.append("**Duplicate action registrations (%d; TFS warns and keeps the first):** %s" %
              (len(dups), "; ".join("%d (%s vs %s)" % x for x in dups[:40]) +
               (" …" if len(dups) > 40 else "") if dups else "none"))
    br.append("**Ids defined twice in `items.xml` (%d):** %s" % (len(dup_defs), compress_ids(dup_defs) or "none"))
    doc.section("Broken references", "\n".join("- " + x for x in br))
    return doc, {"items_defined": len(items), "registered": len(ev),
                 "undefined_registered": len(undefined), "missing_scripts": len(missing_scripts),
                 "dup_actions": len(dups), "gaps": len(gaps),
                 "category_rows": {t: len(r) for t, r, _ in sections}}


# ---------------------------------------------------------------------------------------------
# NPCS.md
# ---------------------------------------------------------------------------------------------

def build_npcs(commit):
    doc = Doc("NPCS.md", "NPC reference", commit)
    n = load_npcs()
    npcs, live, dyn = n["npcs"], n["live"], n["dyn"]
    rows = []
    by_role = defaultdict(int)
    for key, info in npcs.items():
        role = npc_role(info["script"], info["params"])
        by_role[role] += 1
        pos = live.get(info["name"]) or live.get(key) or []
        other = [fn for fn, sp in n["others"].items() if info["name"] in sp or key in sp]
        if pos:
            spawned = "live ×%d" % len(pos) if len(pos) > 1 else "live"
        elif info["name"] in dyn or key in dyn:
            spawned = "dynamic"
        else:
            spawned = "**no**"
        if other and not pos:
            spawned += " (only in %s)" % ", ".join(code(o) for o in other)
        dyn_src = fmt_hits([(f, l, None) for f, l in dyn.get(info["name"], [])], 2)
        shop = ""
        if info["buy"] or info["sell"]:
            shop = "buys %d / sells %d" % (len(info["sell"]), len(info["buy"]))
        rows.append([info["name"] or key, role,
                     code(info["script"]) + ("" if info["script_exists"] or not info["script"]
                                             else " **MISSING**"),
                     spawned, "; ".join("%d,%d,%d" % p for p in pos[:3]) + (" …" if len(pos) > 3 else ""),
                     dyn_src, shop, code(short_path(info["file"]))])
    rows.sort(key=lambda r: r[0].lower())
    # consistency
    cons = []
    names = set(npcs)
    live_missing = sorted(nm for nm in live if nm not in names)
    if live_missing:
        cons.append("**Spawned in `%s` but no `npc/<name>.xml` (case-sensitive lookup in "
                    "`Npc::createNpc`, NPC not created) (%d):** %s" %
                    (n["spawn"], len(live_missing), ", ".join(code(x) for x in live_missing)))
    dyn_missing = sorted(nm for nm in dyn if nm not in names)
    if dyn_missing:
        cons.append("**Created by scripts with `doCreateNpc` but no XML (%d):** %s" %
                    (len(dyn_missing), "; ".join("%s (%s)" % (code(x), fmt_hits([(f, l, None) for f, l in dyn[x]], 2))
                                                for x in dyn_missing)))
    mism = [(k, v["name"]) for k, v in npcs.items() if v["name"] and v["name"] != k]
    if mism:
        cons.append("**XML file name differs from the `name` attribute (%d; spawns use the file "
                    "name):** %s" % (len(mism), ", ".join("`%s.xml` → %s" % m for m in mism)))
    miss = [(k, v["script"]) for k, v in npcs.items() if v["script"] and not v["script_exists"]]
    if miss:
        cons.append("**Script missing (%d):** %s" % (len(miss), ", ".join("%s → `%s`" % m for m in miss)))
    noscript = [k for k, v in npcs.items() if not v["script"]]
    if noscript:
        cons.append("NPCs without a `script` attribute (%d): %s" % (len(noscript), ", ".join(noscript)))
    unspawned = [r[0] for r in rows if r[3].startswith("**no**")]
    used_scripts = set(v["script"] for v in npcs.values())
    orphan = sorted(f for f in os.listdir(os.path.join(DATA, "npc", "scripts"))
                    if f.endswith(".lua") and f not in used_scripts)
    if orphan:
        cons.append("Scripts in `npc/scripts/` used by no NPC XML (%d): %s" %
                    (len(orphan), ", ".join(code(x) for x in orphan)))
    backup = [k for k in npcs if re.search(r"_backup|backup$|\bold\b", k, re.I)]
    if backup:
        cons.append("Backup-looking NPC files: %s" % ", ".join(code(b + ".xml") for b in backup))
    other_counts = ", ".join("`%s` (%d NPC names)" % (fn, len(sp)) for fn, sp in n["others"].items())
    doc.summary.append(md_table(["Metric", "Value"], [
        ["NPC XML files (excluding `tmpCitizen_*`)", len(npcs)],
        ["Generated `tmpCitizen_*.xml` files (excluded)", len(n["tmp"])],
        ["Live spawn file", "`server/data/world/%s`" % n["spawn"]],
        ["NPC spawn entries in the live spawn file", sum(len(v) for v in live.values())],
        ["Distinct NPC names in the live spawn file", len(live)],
        ["NPC XMLs spawned on the live map", sum(1 for r in rows if r[3].startswith("live"))],
        ["NPC XMLs created only by scripts", sum(1 for r in rows if r[3].startswith("dynamic"))],
        ["NPC XMLs never spawned", len(unspawned)],
        ["Other (unused) spawn files", other_counts or "none"],
    ]))
    doc.summary.append("")
    doc.summary.append(md_table(["Role", "NPCs"], sorted(by_role.items(), key=lambda x: -x[1])))
    doc.notes += [
        "The live spawn file is the one named in the map header: config `%s` has `mapName = \"%s\"`, "
        "and the %s names `%s` (house file `%s`). Other `*spawn.xml` files in `server/data/world/` "
        "are **not loaded**." % (n["cfg"], n["mapname"], n["how"], n["spawn"], n["house"]),
        "Spawn positions are `centerx/centery + x/y` and the absolute `z` of each `<npc>` "
        "(`server/src/spawn.cpp:182-200`).",
        "`dynamic` = the name appears in a `doCreateNpc(\"…\")` call (or the NPC list of "
        "`globalevents/scripts/start.lua`) in the active Lua tree.",
        "**Role** is derived from the script file name (and shop parameters for the generic "
        "`default.lua`); it is a heuristic label, not game data.",
        "`tmpCitizen_*.xml` files are regenerated at every start by `systems/027-citizens.lua` "
        "and are not listed.",
    ]
    doc.section("NPCs", md_table(["Name", "Role", "Script", "Spawned", "Live position(s)",
                                  "Created by", "Shop (XML)", "File"], rows))
    doc.section("Consistency notes", "\n".join("- " + c for c in cons) if cons else "_None._")
    return doc, {"npcs": len(npcs), "tmpCitizen": len(n["tmp"]), "live": sum(1 for r in rows if r[3].startswith("live")),
                 "unspawned": len(unspawned), "spawn_without_xml": len(live_missing),
                 "missing_scripts": len(miss)}


# ---------------------------------------------------------------------------------------------
# QUESTS.md
# ---------------------------------------------------------------------------------------------

QUEST_FILE = os.path.join(PSCONF, "003-quest.lua")
QUEST_HOOKS = ("canStart", "onStart", "canFinish", "onEnd", "questStartItems", "startPosition",
               "finishPosition", "blockStart")
QUEST_NPC_FUNCS = r"\b(doQuestTalk|doQuestTalkStart|doQuestTalkEnd|doPlayerStartQuest|getNpcQuests|getNpcRandomQuest)\s*\("


def func_body(f, maxlen=90):
    """'function(cid) return x end' -> 'return x' (whitespace collapsed)."""
    t = re.sub(r"\s+", " ", f.text).strip()
    m = re.match(r"function\s*\([^)]*\)\s*(.*?)\s*end$", t, re.S)
    body = m.group(1) if m else t
    if len(body) > maxlen:
        body = body[:maxlen - 1] + "…"
    return body


def items_with_names(seq):
    """{id, count, id, count} -> '25× Bitten Apple (12115)'."""
    parts = []
    for j in range(0, len(seq) - 1, 2):
        i, c = seq[j], seq[j + 1]
        if is_num(i):
            parts.append("%s× %s (%d)" % (fmt_val(c), item_name(int(i)) or "**undefined item**", int(i)))
        else:
            parts.append("%s× %s" % (fmt_val(c), fmt_val(i)))
    if len(seq) % 2:
        parts.append(fmt_val(seq[-1]))
    return ", ".join(parts)


def quest_request(q, tname):
    r = q.get("questRequest")
    if isinstance(r, Func):
        return "custom: `%s` (line %d)" % (func_body(r).replace("`", "'"), r.line)
    if isinstance(r, LTable):
        a = r.arr()
        if tname == "BRING_ITEMS":
            return "bring " + items_with_names(a)
        if tname in ("DEFEAT_POKEMON", "CATCH_POKEMON") and len(a) == 2:
            return "%s %s× %s" % ("defeat" if tname == "DEFEAT_POKEMON" else "catch", fmt_val(a[1]), fmt_val(a[0]))
        return fmt_val(r, 160)
    if tname == "BRING_POKEMON":
        return "bring a %s" % fmt_val(r)
    if tname == "DEX_POKEMONS":
        return "have %s Pokémon in the Pokédex" % fmt_val(r)
    return fmt_val(r, 160)


def quest_rewards(q, rt_names):
    out = []
    rw = q.get("rewardItems")
    if isinstance(rw, LTable):
        for r in rw.arr():
            if not isinstance(r, LTable):
                out.append(fmt_val(r))
                continue
            t = rt_names.get(r.get("type"), fmt_val(r.get("type")))
            uniq = " (unique)" if r.get("unique") is True else ""
            if t == "ITEM":
                i = r.get("id")
                nm = item_name(int(i)) if is_num(i) else None
                out.append("%s× %s (%s)%s" % (fmt_val(r.get("count")), nm or "**undefined item**",
                                              fmt_val(i), uniq))
            elif t == "POKEMON":
                out.append("Pokémon %s lv %s%s" % (fmt_val(r.get("name")), fmt_val(r.get("level")), uniq))
            elif t == "ADDON":
                f, m = r.get("female"), r.get("male")
                fl = f.get("looktype") if isinstance(f, LTable) else None
                ml = m.get("looktype") if isinstance(m, LTable) else None
                ad = f.get("addons") if isinstance(f, LTable) else None
                out.append("outfit F%s/M%s addons %s" % (fmt_val(fl), fmt_val(ml), fmt_val(ad)))
            else:
                out.append(fmt_val(r, 80))
    elif rw is not None and not (isinstance(rw, Sym) and rw.missing):
        out.append(fmt_val(rw, 80))
    exp = q.get("rewardExp")
    if is_num(exp) and exp:
        out.append("%s exp" % fmt_val(exp))
    return "; ".join(out)


def disabled_quests(text):
    """Commented-out quest blocks: (line, storage, first talk line)."""
    res = []
    for m in re.finditer(r"--\[(=*)\[(.*?)\]\1\]", text, re.S):
        body = m.group(2)
        for sm in re.finditer(r"storage\s*=\s*(\d+)", body):
            if re.search(r"\bfor\s+storage\s*=", body[max(0, sm.start() - 8):sm.end()]):
                continue
            line = text.count("\n", 0, m.start(2) + sm.start()) + 1
            tm = re.search(r'talk_questStarting\s*=\s*"([^"]*)"', body[sm.end():sm.end() + 600])
            res.append((line, int(sm.group(1)), tm.group(1) if tm else ""))
    for i, l in enumerate(text.split("\n"), 1):
        m = re.match(r"\s*--(?!\[=*\[)\s*storage\s*=\s*(\d+)", l)
        if m:
            res.append((i, int(m.group(1)), ""))
    return sorted(res)


def build_quests(commit):
    doc = Doc("QUESTS.md", "Quest reference", commit)
    env = load_constants_env()
    it = env.run_file(QUEST_FILE)
    qcfg = env.g.get("QUESTS_CONFIG")
    if not isinstance(qcfg, LTable):
        qcfg = LTable()
    qt = it.locals.get("QUEST_TYPE") or LTable()
    rt = it.locals.get("REWARD_TYPE") or LTable()
    qt_names = dict((v, k) for k, v in qt.items())
    rt_names = dict((v, k) for k, v in rt.items())
    raw = read(QUEST_FILE)
    stripped = source_index().files.get(rel(QUEST_FILE), strip_lua_comments(raw))
    storage_lines = defaultdict(list)
    for m in re.finditer(r"(?<!for )\bstorage\s*=\s*(\d+)", stripped):
        storage_lines[int(m.group(1))].append(stripped.count("\n", 0, m.start()) + 1)
    n = load_npcs()
    npcs = n["npcs"]
    by_name = {}
    for key, info in npcs.items():
        by_name.setdefault(info["name"] or key, key)
    poke = load_pokemon_data()["pokemon"]
    poke_names = set(k.lower() for k in poke.keys())
    poke_names |= set("shiny " + k for k in list(poke_names))
    poke_names |= set(monsters_index()[0].keys())
    rows = []
    by_type = defaultdict(int)
    storages = defaultdict(list)
    bad_items, bad_pokes = [], []
    npc_rows = []
    hook_count = defaultdict(int)
    daily = 0
    for npc, quests in qcfg.items():
        qs = quests.arr() if isinstance(quests, LTable) else []
        key = by_name.get(npc) or (npc if npc in npcs else None)
        info = npcs.get(key) if key else None
        for j, q in enumerate(qs, 1):
            if not isinstance(q, LTable):
                continue
            st = q.get("storage")
            storages[st].append((npc, j))
            t = q.get("questType")
            tname = qt_names.get(t, fmt_val(t))
            by_type[tname] += 1
            lines = storage_lines.get(st, [])
            idx = len([1 for (nn, jj) in storages[st]]) - 1
            line = lines[idx] if idx < len(lines) else (lines[0] if lines else 0)
            hooks = [h for h in QUEST_HOOKS if q.get(h) is not None and not (isinstance(q.get(h), Sym) and q.get(h).missing)]
            for h in hooks:
                hook_count[h] += 1
            if q.get("daily") is True:
                daily += 1
            req = q.get("questRequest")
            if tname == "BRING_ITEMS" and isinstance(req, LTable):
                a = req.arr()
                for k in range(0, len(a) - 1, 2):
                    if is_num(a[k]) and not item_name(int(a[k])):
                        bad_items.append((npc, st, "request", a[k]))
            if tname in ("DEFEAT_POKEMON", "CATCH_POKEMON", "BRING_POKEMON"):
                nm = req.arr()[0] if isinstance(req, LTable) and req.arr() else req
                if isinstance(nm, str) and nm.lower() not in poke_names:
                    bad_pokes.append((npc, st, nm))
            rw = q.get("rewardItems")
            if isinstance(rw, LTable):
                for r in rw.arr():
                    if isinstance(r, LTable) and rt_names.get(r.get("type")) == "ITEM" and is_num(r.get("id")) \
                            and not item_name(int(r.get("id"))):
                        bad_items.append((npc, st, "reward", r.get("id")))
                    if isinstance(r, LTable) and rt_names.get(r.get("type")) == "POKEMON" \
                            and isinstance(r.get("name"), str) and r.get("name").lower() not in poke_names:
                        bad_pokes.append((npc, st, r.get("name")))
            started = q.get("talk_questStarted")
            summary = fmt_val(started) if isinstance(started, str) else ""
            if len(summary) > 140:
                summary = summary[:139] + "…"
            lvl = q.get("requiredLevel")
            rows.append([fmt_val(st), npc, j, tname, quest_request(q, tname),
                         fmt_val(lvl) if lvl is not None and not (isinstance(lvl, Sym) and lvl.missing) else "",
                         "yes" if q.get("daily") is True else "",
                         quest_rewards(q, rt_names),
                         fmt_val(q.get("counterStorage")) if q.get("counterStorage") is not None else "",
                         ", ".join(hooks), summary, "`003-quest.lua:%d`" % line if line else ""])
        if info:
            spawned = "live" if (info["name"] in n["live"] or key in n["live"]) else (
                "dynamic" if (info["name"] in n["dyn"] or key in n["dyn"]) else "**no**")
            sp = os.path.join(DATA, "npc", "scripts", info["script"]) if info["script"] else None
            questy = bool(sp and os.path.isfile(sp) and re.search(QUEST_NPC_FUNCS, strip_lua_comments(read(sp))))
            npc_rows.append([npc, len(qs), code(short_path(info["file"])), code(info["script"]) +
                             ("" if info["script_exists"] else " **MISSING**"), spawned,
                             "yes" if questy else "**no**"])
        else:
            npc_rows.append([npc, len(qs), "**no XML**", "", "", ""])
    rows.sort(key=lambda r: (int(r[0]) if r[0].isdigit() else 10 ** 9, r[1]))
    dups = [(s, v) for s, v in storages.items() if len(v) > 1]
    dis = disabled_quests(raw)
    active_storages = set(s for s in storages if is_num(s))
    m = re.search(r"LAST STORAGE:\s*(\d+)", raw)
    cons = []
    daily_keys = set((r[1], r[2]) for r in rows if r[6] == "yes")
    npc_storages = defaultdict(set)
    for r in rows:
        npc_storages[r[1]].add(r[0])
    for s, v in sorted(dups, key=lambda x: x[0]):
        per_npc = set(x[0] for x in v)
        if all(len(npc_storages[nm]) > 1 for nm in per_npc) and len(v) == len(per_npc):
            cons.append("**Storage %s is used once by each of %s, which otherwise use distinct storages — "
                        "probably overlapping storage ranges (the quests share one status slot):** %s" %
                        (s, ", ".join(sorted(per_npc)), ", ".join("%s #%d (%s)" % (x[0], x[1], next(
                            (r[11] for r in rows if (r[1], r[2]) == x), "")) for x in v)))
        elif all(x in daily_keys for x in v):
            cons.append("Storage %s is shared by %d daily quests of %d NPCs (%s) — the daily-quest slot, "
                        "progress is kept per NPC in `counterStorage`; by design." %
                        (s, len(v), len(set(x[0] for x in v)), ", ".join(sorted(set(x[0] for x in v)))))
        else:
            cons.append("**Storage %s is used by more than one non-daily quest:** %s" %
                        (s, ", ".join("%s #%d" % x for x in v)))
    mism_talk = []
    for r in rows:
        txt = r[10].lower()
        for word, tname in (("catch", "CATCH_POKEMON"), ("defeat", "DEFEAT_POKEMON")):
            if re.search(r"\b%s \d+ " % word, txt) and r[3] not in (tname, "CUSTOM"):
                mism_talk.append("storage %s (%s #%s): text says \"%s\" but type is %s, request: %s" %
                                 (r[0], r[1], r[2], r[10][:70], r[3], r[4]))
        if r[3] in ("CATCH_POKEMON", "DEFEAT_POKEMON"):
            m2 = re.match(r"\w+ (\S+)× (.+)$", r[4])
            if m2 and re.search(r"\b(catch|defeat) \d+ ", txt) and m2.group(2).lower() not in txt:
                mism_talk.append("storage %s (%s #%s): text \"%s\" but request is %s" %
                                 (r[0], r[1], r[2], r[10][:70], r[4]))
    if mism_talk:
        cons.append("**`talk_questStarted` text does not match the configured request (%d; heuristic "
                    "word match):** %s" % (len(mism_talk), "; ".join(mism_talk)))
    no_xml = [r[0] for r in npc_rows if r[2] == "**no XML**"]
    if no_xml:
        cons.append("**Quest NPC names with no NPC XML whose `name` matches (%d; their quests cannot be "
                    "started):** %s" % (len(no_xml), ", ".join(code(x) for x in no_xml)))
    nosp = [r[0] for r in npc_rows if r[4] == "**no**"]
    if nosp:
        cons.append("Quest NPCs that are neither on the live map nor created by a script (%d): %s" %
                    (len(nosp), ", ".join(code(x) for x in nosp)))
    noq = [r[0] for r in npc_rows if r[5] == "**no**"]
    if noq:
        cons.append("Quest NPCs whose script never calls the quest API (`doQuestTalk`, `getNpcQuests`, …) "
                    "(%d; heuristic, the script may forward to another file): %s" %
                    (len(noq), ", ".join(code(x) for x in noq)))
    if bad_items:
        cons.append("**Item ids not defined in `items.xml` (%d):** %s" % (len(bad_items), "; ".join(
            "%s storage %s %s id %s" % (code(a), b, c, d) for a, b, c, d in bad_items)))
    if bad_pokes:
        cons.append("**Pokémon names that are neither a `POKEMON` config nor a monster (%d):** %s" % (
            len(bad_pokes), "; ".join("%s storage %s: %s" % (code(a), b, code(c)) for a, b, c in bad_pokes)))
    if m and active_storages:
        mx = max(active_storages)
        if int(m.group(1)) != mx:
            cons.append("The header comment says `LAST STORAGE: %s`; the highest active quest storage is %d." %
                        (m.group(1), mx))
    reuse = sorted(set(s for _, s, _ in dis if s in active_storages))
    if reuse:
        cons.append("Storages of commented-out quests that are reused by an active quest: %s" %
                    ", ".join(str(x) for x in reuse))
    warns = [w for w in env.warnings if w[0].endswith("003-quest.lua")]
    if warns:
        cons.append("Parser warnings in `003-quest.lua`: " + "; ".join("line %d: %s" % (w[1], w[2]) for w in warns))
    doc.summary.append(md_table(["Metric", "Value"], [
        ["NPC keys in `QUESTS_CONFIG`", len(qcfg.keys())],
        ["Active quests", len(rows)],
        ["Daily quests", daily],
        ["Commented-out quest blocks (not loaded)", len(dis)],
        ["Storages shared by several quests (daily slots included)", len(dups)],
        ["Talk text / request mismatches (heuristic)", len(mism_talk)],
        ["Quest NPC names without NPC XML", len(no_xml)],
    ] + [["Quests of type %s" % k, v] for k, v in sorted(by_type.items(), key=lambda x: -x[1])]
      + [["Quests using `%s`" % k, v] for k, v in sorted(hook_count.items())]))
    doc.notes += [
        "Source: `server/data/lib/ps/config/003-quest.lua`, loaded by `dofile` from "
        "`lib/ps/systems/002-quest.lua:82` (then copied into the local `QUESTS` table). The file is "
        "evaluated with the generator's Lua interpreter on top of `others/constants.lua`; "
        "`QUEST_TYPE` / `REWARD_TYPE` names come from the file's own local tables.",
        "Quests have **no name field**. They are identified by `storage` (the player storage that "
        "holds the quest status) and by the NPC key + position in that NPC's list. The *Summary* "
        "column is the NPC's `talk_questStarted` line.",
        "NPC keys are matched against the `name` attribute of the NPC XML (`getNpcName()` in "
        "`npc/scripts/quest_default.lua`).",
        "`custom` requests are Lua functions; the column shows the function body, not an evaluation.",
        "Commented-out quests are detected by scanning `--[[ … ]]` blocks and `-- storage =` lines "
        "for `storage = N`; this is heuristic.",
        "Other quest-like content lives elsewhere and is **not** listed here: "
        "`lib/ps/config/001-rangerClub.lua` (Ranger Club tasks), chest quests in "
        "`actions/scripts/quests/`, and the item-request NPC scripts under `npc/scripts/quest_*.lua` "
        "that do not use `QUESTS_CONFIG`.",
    ]
    doc.section("Quests", md_table(["Storage", "NPC", "#", "Type", "Request", "Level", "Daily",
                                    "Rewards", "Counter storage", "Hooks", "Summary (talk_questStarted)",
                                    "Source"], rows))
    doc.section("Quest NPCs", md_table(["NPC key", "Quests", "NPC XML", "Script", "Spawned",
                                        "Script uses quest API"], sorted(npc_rows, key=lambda r: r[0].lower())))
    doc.section("Disabled (commented out) quests",
                ("These blocks are inside Lua comments and are **not loaded**.\n\n" +
                 md_table(["Line", "Storage", "Storage reused by active quest", "talk_questStarting"],
                          [[x[0], x[1], "yes" if x[1] in active_storages else "", x[2]] for x in dis]))
                if dis else "_None._")
    doc.section("Consistency notes", "\n".join("- " + c for c in cons) if cons else "_None._")
    return doc, {"npcs": len(qcfg.keys()), "quests": len(rows), "disabled": len(dis), "dup_storages": len(dups),
                 "npc_without_xml": len(no_xml), "talk_mismatch": len(mism_talk), "bad_items": len(bad_items), "bad_pokemon": len(bad_pokes)}


# ---------------------------------------------------------------------------------------------
# ACHIEVEMENTS.md
# ---------------------------------------------------------------------------------------------

ACH_FILE = os.path.join(PSLIB, "systems", "023-achievement.lua")
STAT_FILE = os.path.join(PSLIB, "events", "creaturescripts", "onStatisticChange.lua")
EVENT_PATH_RX = re.compile(r"/events/(actions|movements)/events/|halloween|christmas|xmas|grinch|easter|"
                           r"anniversary|julyvacation|santa", re.I)


def build_achievements(commit):
    doc = Doc("ACHIEVEMENTS.md", "Achievement reference", commit)
    env = load_constants_env()
    it = env.run_file(ACH_FILE)
    L = it.locals
    ids = env.g.get("ACHIEVEMENT_IDS") or LTable()
    names = L.get("ACHIEVEMENT_NAMES") or LTable()
    descs = L.get("ACHIEVEMENT_DESCRIPTIONS") or LTable()
    checks = L.get("ACHIEVEMENT_CHECKS") or LTable()
    series = L.get("ACHIEVEMENT_SERIES") or LTable()
    secret = L.get("SECRET_ACHIEVEMENTS") or LTable()
    ranks = L.get("ACHIEVEMENT_RANKS") or LTable()
    rank_ids = L.get("RANK_IDS") or LTable()
    score = L.get("SCORE_BY_RANKS") or LTable()
    rank_names = dict((v, k) for k, v in rank_ids.items())
    stat_ids = env.g.get("PLAYER_STATISTIC_IDS") or LTable()
    by_id = OrderedDict()
    for k, v in ids.items():
        by_id.setdefault(v, []).append(k)
    # statistic -> head achievement
    stxt = strip_lua_comments(read(STAT_FILE))
    stat_map = OrderedDict()
    for m in re.finditer(r"PLAYER_STATISTIC_IDS\.(\w+)\s*\)\s*then\s*doPlayerAchievementCheck\s*\(\s*cid\s*,\s*"
                         r"ACHIEVEMENT_IDS\.(\w+)", stxt):
        stat_map[m.group(2)] = m.group(1)
    # who increments each statistic
    stat_inc = defaultdict(list)
    idx = source_index()
    for f, line, m in idx.grep(r"doPlayerAddStatistic\s*\([^,]+,\s*PLAYER_STATISTIC_IDS\.(\w+)"):
        stat_inc[m.group(1)].append((f, line, m))
    for f, line, m in idx.grep(r"\bplayerAddStatistic\s*\([^,;]+,\s*([A-Z_][A-Z0-9_]*)\s*,"):
        if f.endswith((".cpp", ".h")):
            stat_inc[m.group(1)].append((f, line, m))
    # direct references
    skip = (rel(ACH_FILE), rel(STAT_FILE))
    direct = defaultdict(list)
    other_ref = defaultdict(list)
    undefined = []
    for f, line, m in idx.grep(r"(doPlayerAchievementCheck\s*\([^,]+,\s*)?ACHIEVEMENT_IDS\.(\w+)", exclude=skip):
        nm = m.group(2)
        if nm not in ids.keys():
            undefined.append((f, line, nm))
            continue
        (direct if m.group(1) else other_ref)[nm].append((f, line, m))
    # series predecessor
    pred = {}
    for a, b in series.items():
        pred[b] = a
    rows = []
    status_count = defaultdict(int)
    unreachable = []
    for aid in sorted(k for k in by_id if is_num(k)):
        for key in by_id[aid]:
            chain = [aid]
            seen = set([aid])
            while chain[-1] in pred and pred[chain[-1]] not in seen:
                chain.append(pred[chain[-1]])
                seen.add(chain[-1])
            triggers = []
            reach = False
            event_only = True
            for c in chain:
                for ck in by_id.get(c, []):
                    if ck in stat_map:
                        st = stat_map[ck]
                        inc = stat_inc.get(st, [])
                        via = "" if ck == key else " via series from `%s`" % ck
                        if inc:
                            triggers.append("statistic `%s`%s (incremented in %s)" % (st, via, fmt_hits(inc, 3)))
                            reach = True
                            if not all(EVENT_PATH_RX.search(h[0]) for h in inc):
                                event_only = False
                        else:
                            triggers.append("statistic `%s`%s — **never incremented**" % (st, via))
                    if direct.get(ck):
                        via = "" if ck == key else " via series from `%s`" % ck
                        triggers.append("`doPlayerAchievementCheck`%s in %s" % (via, fmt_hits(direct[ck], 3)))
                        reach = True
                        if not all(EVENT_PATH_RX.search(h[0]) for h in direct[ck]):
                            event_only = False
            if not reach:
                status = "UNREACHABLE"
                unreachable.append(key)
            elif event_only:
                status = "EVENT-GATED"
            else:
                status = "REACHABLE"
            status_count[status] += 1
            chk = checks.get(aid)
            cond = "`%s`" % func_body(chk).replace("`", "'") if isinstance(chk, Func) else (
                "none (granted on first call)" if chk is None else fmt_val(chk))
            rk = ranks.get(aid)
            rname = rank_names.get(rk, fmt_val(rk))
            pts = score.get(rk)
            nxt = series.get(aid)
            nxt_s = ", ".join(by_id.get(nxt, [fmt_val(nxt)])) if nxt is not None else ""
            rows.append([aid, key, fmt_val(names.get(aid)), fmt_val(descs.get(aid)), cond, rname,
                         "%s points" % fmt_val(pts) if pts is not None else "**none**",
                         "yes" if secret.get(aid) is True else "", nxt_s,
                         "; ".join(triggers) or "**none**",
                         fmt_hits(other_ref.get(key, []), 3), status])
    cons = []
    if unreachable:
        commented = defaultdict(list)
        rx = re.compile(r"ACHIEVEMENT_IDS\.(%s)\b" % "|".join(re.escape(x) for x in unreachable))
        for dp, dns, fns in os.walk(DATA):
            for fn in fns:
                if not fn.endswith(".lua"):
                    continue
                p = os.path.join(dp, fn)
                if p in (ACH_FILE, STAT_FILE):
                    continue
                raw = read(p)
                for m in rx.finditer(raw):
                    commented[m.group(1)].append((rel(p), raw.count("\n", 0, m.start()) + 1, None))
        cons.append("**UNREACHABLE achievements (%d)** — no active `doPlayerAchievementCheck` call and no "
                    "incremented statistic reaches them (directly or through `ACHIEVEMENT_SERIES`): %s" %
                    (len(unreachable), ", ".join(
                        code(x) + (" (referenced only in commented-out or historical code: %s)" %
                                   fmt_hits(commented[x], 2) if commented.get(x) else "")
                        for x in unreachable)))
    never = [(st, a) for a, st in stat_map.items() if not stat_inc.get(st)]
    if never:
        hist = []
        for st, a in never:
            h = [x for x in idx.grep(r"PLAYER_STATISTIC_IDS\.%s\b" % st, active_only=False)
                 if is_historical(os.path.join(ROOT, x[0]))]
            hist.append("`%s` → `%s`%s" % (st, a, (" (only incremented in historical %s)" % fmt_hits(h, 2)) if h else ""))
        cons.append("**Statistics mapped in `onStatisticChange.lua` but never incremented by active code:** " +
                    "; ".join(hist))
    unmapped = [k for k in stat_ids.keys() if k not in stat_map.values()]
    if unmapped:
        cons.append("Statistics with no achievement mapping in `onStatisticChange.lua`: %s" %
                    ", ".join(code(x) for x in unmapped))
    unknown_stat = [a for a in stat_map if a not in ids.keys()]
    if unknown_stat:
        cons.append("**`onStatisticChange.lua` references undefined achievement ids:** %s" %
                    ", ".join(code(x) for x in unknown_stat))
    if undefined:
        cons.append("**References to undefined `ACHIEVEMENT_IDS` fields:** %s" %
                    "; ".join("`%s` (%s)" % (nm, fmt_hits([(f, l, None)], 1)) for f, l, nm in undefined))
    dup_ids = [(k, v) for k, v in by_id.items() if len(v) > 1]
    if dup_ids:
        cons.append("**Numeric id shared by several `ACHIEVEMENT_IDS` names:** %s" %
                    "; ".join("%s → %s" % (k, ", ".join(v)) for k, v in dup_ids))
    nums = sorted(k for k in by_id if is_num(k))
    gaps = [x for x in range(nums[0], nums[-1] + 1) if x not in by_id] if nums else []
    if gaps:
        cons.append("Unused ids between %d and %d: %s" % (nums[0], nums[-1], compress_ids(gaps)))
    for label, tbl in (("name", names), ("description", descs), ("rank", ranks)):
        miss = [by_id[a][0] for a in nums if tbl.get(a) is None]
        if miss:
            cons.append("**Achievements without a %s (%d):** %s" % (label, len(miss), ", ".join(code(x) for x in miss)))
    orphan_tbl = [(label, k) for label, tbl in (("ACHIEVEMENT_NAMES", names), ("ACHIEVEMENT_CHECKS", checks),
                                                ("ACHIEVEMENT_SERIES", series), ("ACHIEVEMENT_RANKS", ranks))
                  for k in tbl.keys() if k not in by_id]
    if orphan_tbl:
        cons.append("Table entries keyed by an id with no `ACHIEVEMENT_IDS` name: %s" %
                    ", ".join("%s[%s]" % x for x in orphan_tbl))
    warns = [w for w in env.warnings if w[0].endswith("023-achievement.lua")]
    if warns:
        cons.append("Parser warnings: " + "; ".join("line %d: %s" % (w[1], w[2]) for w in warns))
    doc.summary.append(md_table(["Metric", "Value"], [
        ["Achievements (`ACHIEVEMENT_IDS`)", len(rows)],
        ["With a check function", len([k for k in checks.keys()])],
        ["Series links (`ACHIEVEMENT_SERIES`)", len(series.keys())],
        ["Secret", len([k for k, v in secret.items() if v is True])],
        ["Statistic → achievement mappings", len(stat_map)],
    ] + [["Status %s" % k, v] for k, v in sorted(status_count.items())]
      + [["Rank %s" % rank_names.get(k, k), "%d achievements, %s points each" %
          (sum(1 for a in nums if ranks.get(a) == k), fmt_val(score.get(k)))] for k in sorted(rank_names)]))
    doc.notes += [
        "Source: `server/data/lib/ps/systems/023-achievement.lua`, evaluated on top of "
        "`others/constants.lua`. Statistic mappings come from a regex over "
        "`lib/ps/events/creaturescripts/onStatisticChange.lua` (registered in "
        "`creaturescripts.xml` and `creaturescripts/scripts/login.lua`).",
        "**Reward**: `doPlayerAchievementCheck` inserts a `player_achievements` row, adds "
        "`SCORE_BY_RANKS[rank]` to `HIGHSCORE_IDS.ACHIEVEMENTS` and increments the "
        "`EARN_ACHIEVEMENT` statistic. No achievement gives items.",
        "**Condition**: the check function receives the new statistic value (`var`); achievements "
        "without a check are granted on the first `doPlayerAchievementCheck` call.",
        "`ACHIEVEMENT_SERIES[a] = b`: once `a` is owned, a check of `a` continues with `b` using the "
        "same value, so later steps of a series share the first step's trigger.",
        "A statistic counts as incremented when active Lua calls `doPlayerAddStatistic(…, "
        "PLAYER_STATISTIC_IDS.X, …)` or C++ calls `g_game.playerAddStatistic(…, X, …)`. Historical "
        "trees (`systems/disabled`, …) are ignored.",
        "**EVENT-GATED** = every trigger lives in a seasonal event path (Halloween, Christmas, Easter, "
        "anniversary, July vacation); those events are date-driven. This is a path-name heuristic.",
        "*Other references* lists non-trigger uses of the id (ownership checks, menus, tables of ids "
        "passed to `doPlayerAchievementCheck` indirectly). When the id is only used through such a "
        "table, the achievement may be reported UNREACHABLE although it is reachable — check those "
        "rows by hand.",
    ]
    doc.section("Achievements", md_table(["Id", "Key", "Name", "Description", "Condition (check)", "Rank",
                                          "Reward", "Secret", "Next in series", "Trigger",
                                          "Other references", "Status"], rows))
    doc.section("Statistic mappings", md_table(
        ["Statistic", "Id", "First achievement", "Incremented by"],
        [[st, fmt_val(stat_ids.get(st)), a, fmt_hits(stat_inc.get(st, []), 4) or "**never**"]
         for a, st in stat_map.items()]))
    doc.section("Consistency notes", "\n".join("- " + c for c in cons) if cons else "_None._")
    return doc, {"achievements": len(rows), "unreachable": len(unreachable),
                 "statuses": dict(status_count), "stat_mappings": len(stat_map)}


# ---------------------------------------------------------------------------------------------
# DATABASE.md
# ---------------------------------------------------------------------------------------------

SCHEMA_DIR = os.path.join(SRC, "schemas")
SCHEMA_FILES = ["mysql.sql", "psoul_extra_mysql.sql", "psoul_dev_seed.sql"]
SQL_READ_KW = r"FROM|JOIN"
SQL_WRITE_KW = r"INSERT\s+(?:IGNORE\s+)?INTO|REPLACE\s+INTO|UPDATE|DELETE\s+FROM|TRUNCATE(?:\s+TABLE)?"


def strip_sql_comments(s):
    s = re.sub(r"/\*.*?\*/", lambda m: re.sub(r"[^\n]", " ", m.group(0)), s, flags=re.S)
    return re.sub(r"--[^\n]*", "", s)


def matching_paren(s, i):
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "(":
            depth += 1
        elif s[j] == ")":
            depth -= 1
            if depth == 0:
                return j
    return len(s)


def parse_schema(path):
    """-> tables{name: {cols[(name,type)], like, line}}, alters{table: [(col,type,line)]},
          inserts{table: [line]}, triggers[(name, table, line)]"""
    text = strip_sql_comments(read(path))
    tables, alters, inserts, triggers = OrderedDict(), defaultdict(list), defaultdict(list), []
    for m in re.finditer(r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?\s*(LIKE\s+`?(\w+)`?|\()",
                         text, re.I):
        line = text.count("\n", 0, m.start()) + 1
        if m.group(3):
            tables[m.group(1)] = dict(cols=[], like=m.group(3), line=line)
            continue
        start = m.end() - 1
        body = text[start + 1:matching_paren(text, start)]
        cols = []
        for part in re.split(r",\s*\n", body):
            cm = re.match(r"\s*`(\w+)`\s+([A-Za-z]+(?:\s*\([^)]*\))?(?:\s+UNSIGNED)?)", part, re.I)
            if cm:
                cols.append((cm.group(1), re.sub(r"\s+", " ", cm.group(2))))
        tables[m.group(1)] = dict(cols=cols, like=None, line=line)
    for m in re.finditer(r"ALTER\s+TABLE\s+`?(\w+)`?(.*?);", text, re.I | re.S):
        for cm in re.finditer(r"ADD\s+(?:COLUMN\s+)?(?:IF\s+NOT\s+EXISTS\s+)?`(\w+)`\s+([A-Za-z]+(?:\s*\([^)]*\))?"
                              r"(?:\s+UNSIGNED)?)", m.group(2), re.I):
            line = text.count("\n", 0, m.start(2) + cm.start()) + 1
            alters[m.group(1)].append((cm.group(1), cm.group(2), line))
    for m in re.finditer(r"INSERT\s+(?:IGNORE\s+)?INTO\s+`?(\w+)`?", text, re.I):
        inserts[m.group(1)].append(text.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"CREATE\s+TRIGGER\s+`?(\w+)`?.*?\bON\s+`?(\w+)`?", text, re.I | re.S):
        triggers.append((m.group(1), m.group(2), text.count("\n", 0, m.start()) + 1))
    return tables, alters, inserts, triggers


def enclosing_lua_function(txt, pos):
    best = None
    for m in re.finditer(r"^\s*(?:local\s+)?function\s+([\w.:]+)\s*\(", txt[:pos], re.M):
        best = m.group(1)
    return best


def build_database(commit):
    doc = Doc("DATABASE.md", "Database reference", commit)
    tables = OrderedDict()   # name -> info
    alters = defaultdict(list)
    seeds = defaultdict(list)
    triggers = []
    for fn in SCHEMA_FILES:
        p = os.path.join(SCHEMA_DIR, fn)
        if not os.path.isfile(p):
            continue
        t, a, ins, trg = parse_schema(p)
        for name, info in t.items():
            if name in tables:
                tables[name].setdefault("also", []).append("%s:%d" % (fn, info["line"]))
                continue
            info["file"] = fn
            if info["like"]:
                src = tables.get(info["like"]) or t.get(info["like"])
                info["cols"] = list(src["cols"]) if src else []
            tables[name] = info
        for k, v in a.items():
            alters[k] += [(c, ty, fn, ln) for c, ty, ln in v]
        for k, v in ins.items():
            seeds[k] += ["%s:%s" % (fn, ",".join(str(x) for x in v[:3]))]
        triggers += [(n_, tb, fn, ln) for n_, tb, ln in trg]
    known = set(tables)
    kw_rx = re.compile(r"(?:(?P<w>%s)|(?P<r>%s))\s+(?P<q>`?)(?P<t>[A-Za-z_]\w*)(?P=q)" % (SQL_WRITE_KW, SQL_READ_KW),
                       re.I)
    reads, writes = defaultdict(list), defaultdict(list)
    unknown = defaultdict(list)
    writer_funcs = defaultdict(set)
    idx = source_index()
    for f, txt in idx.active():
        if not f.endswith((".lua", ".cpp", ".h")):
            continue
        for m in kw_rx.finditer(txt):
            t = m.group("t")
            kw = m.group("w") or m.group("r")
            if re.search(r"KEY\s*$", txt[max(0, m.start() - 12):m.start()], re.I):
                continue  # ON DUPLICATE KEY UPDATE `col`
            quoted = bool(m.group("q"))
            if not quoted and kw != kw.upper():
                continue
            if t not in known:
                if quoted and t.lower() not in ("select", "set", "where"):
                    unknown[t].append((f, txt.count("\n", 0, m.start()) + 1, m))
                continue
            line = txt.count("\n", 0, m.start()) + 1
            if m.group("w"):
                writes[t].append((f, line, m))
                if f.endswith(".lua"):
                    fn_ = enclosing_lua_function(txt, m.start())
                    if fn_:
                        writer_funcs[t].add((fn_, f))
            else:
                pre = txt[max(0, m.start() - 7):m.start()]
                if re.search(r"DELETE\s*$", pre, re.I):
                    continue
                reads[t].append((f, line, m))
    # writer functions that nobody calls
    dead_writers = defaultdict(list)
    for t, fns in writer_funcs.items():
        for fn_, f in sorted(fns):
            if writes[t] and all(h[0] != f for h in writes[t]):
                continue
            short = fn_.split(".")[-1].split(":")[-1]
            if not re.match(r"do|get|set|update|add|remove|insert|delete|save|load", short, re.I):
                continue
            calls = idx.grep(r"\b%s\b(?!\s*-)" % re.escape(short))
            calls = [c for c in calls if not re.search(r"function\s+[\w.:]*%s$" % re.escape(short),
                                                       idx.files[c[0]][max(0, c[2].start() - 60):c[2].end()])]
            if not calls:
                dead_writers[t].append("%s (%s)" % (fn_, short_path(f)))
    rows = []
    status_count = defaultdict(int)
    for name, info in tables.items():
        r, w = reads.get(name, []), writes.get(name, [])
        if r and w:
            status = "SERVER (read/write)"
        elif w:
            status = "WRITE-ONLY (log; nothing in this repo reads it)"
        elif r:
            status = "WEBSITE-DEPENDENT (server only reads it; nothing in this repo writes it)"
        else:
            status = "UNUSED (no query in active server source)"
        if w and dead_writers.get(name) and len(set(h[0] for h in w)) == 1:
            status += "; writer never called: " + ", ".join(code(x) for x in dead_writers[name])
        status_count[status.split(" ")[0].split(";")[0]] += 1
        cols = [c for c, _ in info["cols"]]
        extra = [c for c, _, _, _ in alters.get(name, [])]
        col_s = ", ".join(cols) + ((" + ALTER: " + ", ".join(extra)) if extra else "")
        created = "`%s:%d`" % (info["file"], info["line"]) + (" (LIKE `%s`)" % info["like"] if info["like"] else "")
        if info.get("also"):
            created += "; also " + ", ".join(code(x) for x in info["also"])
        rows.append([code(name), created, len(cols) + len(extra), col_s,
                     fmt_hits(r, 5) or "—", fmt_hits(w, 5) or "—",
                     ", ".join(code(x) for x in seeds.get(name, [])), status])
    cons = []
    system_tbl = dict((t, h) for t, h in unknown.items() if t in ("information_schema", "sqlite_master"))
    migration = dict((t, h) for t, h in unknown.items() if t not in system_tbl and
                     all(x[0].endswith("databasemanager.cpp") for x in h) and re.search(r"\d$", t))
    for t in list(system_tbl) + list(migration):
        unknown.pop(t)
    if unknown:
        cons.append("**Tables used in queries but created by no schema file (%d):** %s" % (len(unknown), "; ".join(
            "`%s` (%s)" % (t, fmt_hits(h, 3)) for t, h in sorted(unknown.items()))))
    if migration:
        cons.append("Temporary tables used only by the stock schema-upgrade code in `databasemanager.cpp` "
                    "(not expected in a schema): %s" % ", ".join(code(x) for x in sorted(migration)))
    if system_tbl:
        cons.append("Database system catalogs queried by `databasemanager.cpp`: %s" %
                    ", ".join(code(x) for x in sorted(system_tbl)))
    calls = idx.grep(r"CALL\s+`?(\w+)`?")
    procs = [(f, l, m) for f, l, m in calls if f.endswith((".lua", ".cpp"))]
    if procs:
        defined = set()
        for fn in SCHEMA_FILES:
            p = os.path.join(SCHEMA_DIR, fn)
            if os.path.isfile(p):
                defined |= set(re.findall(r"CREATE\s+PROCEDURE\s+`?(\w+)`?", read(p), re.I))
        for f, l, m in procs:
            if m.group(1) not in defined:
                cons.append("**Stored procedure `%s` is called at `%s:%d` but no schema defines it** "
                            "(BUG-25 in `docs/BUG_TRIAGE.md`)." % (m.group(1), short_path(f), l))
    for t, cols in alters.items():
        if t not in tables:
            cons.append("**`ALTER TABLE %s` targets a table no schema creates.**" % t)
    seed_unknown = [t for t in seeds if t not in tables]
    if seed_unknown:
        cons.append("**Seed INSERTs into undefined tables:** %s" % ", ".join(code(x) for x in seed_unknown))
    others = []
    for fn in ("pgsql.sql", "sqlite.sql"):
        p = os.path.join(SCHEMA_DIR, fn)
        if os.path.isfile(p):
            ot = parse_schema(p)[0]
            stock = [n_ for n_, i in tables.items() if i["file"] == "mysql.sql"]
            missing = [x for x in stock if x not in ot]
            others.append("`%s`: %d tables (stock TFS only%s)" % (
                fn, len(ot), ("; missing vs mysql.sql: " + ", ".join(code(x) for x in missing)) if missing else ""))
    doc.summary.append(md_table(["Metric", "Value"], [
        ["Tables in `mysql.sql`", sum(1 for i in tables.values() if i["file"] == "mysql.sql")],
        ["Tables in `psoul_extra_mysql.sql`", sum(1 for i in tables.values() if i["file"] == "psoul_extra_mysql.sql")],
        ["Columns added by `ALTER TABLE`", sum(len(v) for v in alters.values())],
        ["Tables seeded by INSERTs", len(seeds)],
        ["Triggers", len(triggers)],
        ["Tables queried but not created by any schema", len(unknown)],
    ] + [["Status %s" % k, v] for k, v in sorted(status_count.items())]))
    doc.notes += [
        "Schemas: `server/src/schemas/mysql.sql` (stock TFS 0.3.6), `psoul_extra_mysql.sql` "
        "(PSoul tables + `ALTER TABLE … ADD COLUMN IF NOT EXISTS`), `psoul_dev_seed.sql` (INSERTs only). "
        "Apply in that order. `pgsql.sql` / `sqlite.sql` exist but are stock TFS only: " +
        ("; ".join(others) if others else "not found") + ".",
        "Readers/writers are found with a regex over the active, comment-stripped C++ (`server/src`) "
        "and Lua (`server/data`) source: `FROM` / `JOIN` = read; `INSERT INTO`, `REPLACE INTO`, "
        "`UPDATE`, `DELETE FROM`, `TRUNCATE` = write. Unquoted table names only count after an "
        "upper-case keyword. Queries assembled from variables (table name not literal) are missed.",
        "No website code is in this repository, so **WEBSITE-DEPENDENT** means \"the server only "
        "reads this table; rows must be created by the website, an admin, or a seed\". "
        "**WRITE-ONLY** tables are logs that only an external tool (website, analytics) could read.",
        "\"writer never called\" = the only writing code is a Lua function that is not called "
        "anywhere in the active tree (heuristic name match).",
        "Column lists are parsed from the `CREATE TABLE` body (keys and constraints skipped); "
        "`LIKE` clones copy the source table's columns.",
    ]
    doc.section("Tables", md_table(["Table", "Created by", "Cols", "Columns", "Read by", "Written by",
                                    "Seeded by", "Status"], rows))
    doc.section("Columns added with ALTER TABLE", md_table(
        ["Table", "Column", "Type", "Source"],
        [[code(t), code(c), ty, "`%s:%d`" % (fn, ln)] for t, v in alters.items() for c, ty, fn, ln in v]))
    doc.section("Triggers", md_table(["Trigger", "Table", "Source"],
                                     [[code(n_), code(t), "`%s:%d`" % (fn, ln)] for n_, t, fn, ln in triggers])
                if triggers else "_None._")
    col_rows = []
    for name, info in tables.items():
        for c, ty in info["cols"]:
            col_rows.append([code(name), code(c), ty])
        for c, ty, fn, ln in alters.get(name, []):
            col_rows.append([code(name), code(c), ty + " (ALTER, `%s:%d`)" % (fn, ln)])
    doc.section("Column types", md_table(["Table", "Column", "Type"], col_rows))
    doc.section("Consistency notes", "\n".join("- " + c for c in cons) if cons else "_None._")
    return doc, {"tables": len(tables), "statuses": dict(status_count), "unknown_tables": len(unknown),
                 "alter_columns": sum(len(v) for v in alters.values())}


# ---------------------------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------------------------

BUILDERS = OrderedDict([
    ("COMMANDS", build_commands),
    ("POKEMON", build_pokemon),
    ("MOVES", build_moves),
    ("POKEBALLS", build_pokeballs),
    ("ITEMS", build_items),
    ("NPCS", build_npcs),
    ("QUESTS", build_quests),
    ("ACHIEVEMENTS", build_achievements),
    ("DATABASE", build_database),
])


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--only", help="comma separated catalog names (e.g. COMMANDS,MOVES)")
    args = ap.parse_args(argv)
    commit = git_commit()
    wanted = [x.strip().upper() for x in args.only.split(",")] if args.only else list(BUILDERS)
    results = OrderedDict()
    for name in wanted:
        if name not in BUILDERS:
            ap.error("unknown catalog %s (known: %s)" % (name, ", ".join(BUILDERS)))
        doc, stats = BUILDERS[name](commit)
        path = doc.write()
        results[name] = stats
        print("wrote %s  %s" % (rel(path), stats))
    return 0


if __name__ == "__main__":
    sys.exit(main())
