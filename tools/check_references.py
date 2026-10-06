#!/usr/bin/env python3
"""Static cross-reference checker for PokeNation (server + client).

Audit tool, stdlib only. It never modifies the tree. It resolves every file path, name and
id that the server XML registries, the server Lua, the Pokemon/quest configs, the client
modules and the network protocol refer to, the same way the engines do, and reports the
references that do not resolve.

Usage:
    python3 tools/check_references.py               # summary + REAL ERROR list, exit 0
    python3 tools/check_references.py --all         # every finding
    python3 tools/check_references.py --markdown    # findings as markdown tables
    python3 tools/check_references.py --json        # machine-readable findings
    python3 tools/check_references.py --strict      # exit 1 on REAL ERROR not allowlisted
    python3 tools/check_references.py --write-allowlist  # print allowlist for current errors

Resolution rules mirrored from the engines (see docs/BROKEN_REFERENCES.md for citations):
  * server CWD is server/, getDataDir() == "data/" (config.lua dataDirectory)
  * <subsystem>.xml event scripts resolve under data/<subsystem>/scripts/ (baseevents.cpp)
  * NPC script="x" resolves under data/npc/scripts/ unless it contains "/" (npc.cpp)
  * raids.xml file= under data/raids/, raid <script file=> under data/raids/scripts/
  * monsters.xml names are case-insensitive; NPC names map to data/npc/<name>.xml on a
    case-sensitive filesystem; creature event names are case-sensitive (std::map)
  * client PhysFS roots: client/modules, client/data and the work dir client/ all mounted at
    "/", relative paths resolve against the calling script's directory; image paths get
    ".png", otui ".otui", lua ".lua", sounds ".ogg" appended when missing
"""

import argparse
import bisect
import difflib
import json
import os
import re
import sys
import xml.parsers.expat
from collections import Counter, OrderedDict, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SERVER = os.path.join(ROOT, "server")
DATA = os.path.join(SERVER, "data")
CLIENT = os.path.join(ROOT, "client")
CLIENT_MODULES = os.path.join(CLIENT, "modules")
CLIENT_DATA = os.path.join(CLIENT, "data")
ALLOWLIST = os.path.join(ROOT, "tools", "check_references_allowlist.txt")

REAL = "REAL ERROR"
COMMENTED = "COMMENTED/DISABLED"
HISTORICAL = "HISTORICAL BACKUP"
FALSE_POSITIVE = "FALSE POSITIVE"
CLIENT_DEP = "CLIENT-DEPENDENT"
WEBSITE_DEP = "WEBSITE-DEPENDENT"
CLASSES = [REAL, COMMENTED, HISTORICAL, FALSE_POSITIVE, CLIENT_DEP, WEBSITE_DEP]

HISTORICAL_DIRS = [
    "server/data/lib/ps/config/_pokemon/",
    "server/data/lib/ps/others/pokemon_backup/",
    "server/data/lib/ps/others/moves_disabled/",
    "server/data/lib/ps/systems/disabled/",
    "server/data/lib/disabled/",
    "server/data/npc/backup/",
]
HISTORICAL_FILE_RE = re.compile(r"(_backup\.(xml|lua)$|\.bak$|/-spawn\.xml$|/-house\.xml$)")

EVENT_SUBSYSTEMS = OrderedDict([
    ("actions", {"action"}),
    ("movements", {"movevent", "moveevent", "movement"}),
    ("talkactions", {"talkaction"}),
    ("creaturescripts", {"event", "creaturevent", "creatureevent", "creaturescript"}),
    ("globalevents", {"globalevent"}),
    ("spells", {"instant", "rune", "conjure"}),
    ("weapons", {"melee", "distance", "ammunition", "wand"}),
])

# Manual classification, applied after the automatic one. Each entry is
# (check, regex on "file|target", class, note, bug id). First match wins.
OVERRIDES = [
    ("npc.script", r"^server/data/npc/Soya\.xml\|", COMMENTED,
     "stock TFS buyer NPC, in no spawn file; only reachable with /n Soya", "BUG-38"),
    ("spawn.npc", r"^server/data/world/-spawn\.xml\|", HISTORICAL,
     "-spawn.xml is not the map's spawn file (OTBM header names map-spawn.xml)", "BUG-15"),
    ("spawn.monster", r"^server/data/world/-spawn\.xml\|", HISTORICAL,
     "-spawn.xml is not the map's spawn file (OTBM header names map-spawn.xml)", ""),
    ("quest.npc", r"\|PokeMart$", FALSE_POSITIVE,
     "placeholder key ('Default name, isn't really a NPC name', 003-quest.lua:5073) used by quest_pokemart.lua", ""),
    ("quest.npc.unspawned", r"\|(Snap|Easter Rabbit)$", COMMENTED,
     "Easter event NPC; only placed by the stale -spawn.xml / during the event (no live Easter hook)", ""),
    ("quest.npc.unspawned", r"\|Santa Claus$", COMMENTED,
     "Christmas event NPC; all Christmas raids are commented out (raids.xml:14-19)", ""),
    ("quest.npc.unspawned", r"\|(Ed Blackhood|Barba Roja|Javy Dones|Jack Spearow|Calico)$", COMMENTED,
     "Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22)", ""),
    ("quest.npc.unspawned", r"\|Ray Fitz$", COMMENTED,
     "superseded beginner guide (the Red tutorial replaced him; quest_professorOak.lua:139 hint is commented); "
     "the PokeMart 'Ray's order' quest (003-quest.lua:5072) is therefore unreachable", ""),
    ("client.path.dynamic", r"game_tutorial/tutorial\.lua\|", FALSE_POSITIVE,
     "loop 1..39 verified: content/en and content/pt both hold 01.lua..39.lua", ""),
    ("client.path.dynamic", r"game_guide/guide\.lua\|", FALSE_POSITIVE,
     "names come from the server; resolved by the client.guideImage check", ""),
    ("client.extopcode", r"\|103$", COMMENTED,
     "game_shop module is never loaded; server never sends 103", "BUG-38"),
    ("client.extopcode.locale", r"", CLIENT_DEP,
     "client_locales registers opcode 1 but locales travel in the login packet", "BUG-09"),
    ("client.extopcode.send", r"\|1$", COMMENTED,
     "sendLocale() stub is never called (locale sent in the login packet)", "BUG-09"),
    ("client.extopcode.send", r"\|2$", CLIENT_DEP,
     "C++ ProtocolGame sends opcode 2 (ping) on login; server has no extendedopcode event", ""),
]

# Manual impact notes for REAL ERROR findings: (check, regex on target, impact, bug id).
IMPACTS = [
    ("pokemon.ability", r"^Strenght$", "species never get the Strength field ability (BUG-30 lists 11; 59 are affected)", "BUG-30"),
    ("pokemon.ability", r"^Rock Slide$", "'Rock Slide' is a move, not a field ability; entry is ignored", ""),
    ("pokemon.ability", r"^RockMSmash$", "Mewtwo never gets Rock Smash", ""),
    ("pokemon.eggMove.typo", r"", "egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered", ""),
    ("pokemon.tm", r"^TM_IDS\.TAUNT$", "no Taunt TM exists, so nothing is lost; the nil hole can make "
     "table.random(#t) in npcbattle_{lorelei,lance,agatha,bruno}.lua:28 pick nil", ""),
    ("pokemon.tm", r"", "the species cannot learn that TM (nil in learnableTms; table.find skips it)", ""),
    ("pokemon.specialAbility", r"", "species silently lacks that special ability (nil entry)", ""),
    ("pokemon.itemid", r"^135600$", "Kingler dexPortrait typo (13600 intended); inert, getPokemonDexPortraitId() has no caller", ""),
    ("protocol.psoul.listener", r"", "0xFF/0x02 and 0x03 (move bar close/open) reach no Lua handler: game_pokemoves "
     "listens to onPokemonMovesOpen/Close, so the move bar is never hidden by the server (stale bar after recall); "
     "inherited from the archive", ""),
    ("lua.creatureEvent", r"^onLogout_EliteFour$", "registration returns false; inert because the generic "
     "onLogout.lua:37-38 already removes the Elite Four challenger", ""),
    ("lua.createMonster", r"^Scarab$", "stock TFS shovel: 15% of digs log 'monster not found' (no Scarab here)", ""),
    ("client.otui", r"mapflags", "minimap flag icons render blank (mapflags.png missing; only flag0.png ships)", ""),
    ("client.otui", r"combobox_rounded", "market combobox has no background image", ""),
    ("quest.npc.unspawned", r"^London Hamnet$", "quest NPC with QUESTS_CONFIG entry is not on the map; quest unreachable", "BUG-15"),
    ("sql.table", r"^parcels$", "every player-to-player parcel logs an SQL error ('PS - Parcel log', "
     "IOLoginData::playerMail); the parcel itself is delivered", ""),
]

STRICT_CLASSES = {REAL}

# Real Pokemon move names that are one or two letters away from an implemented move, so the
# near-match typo heuristic must not treat them as misspellings.
GENUINE_UNIMPLEMENTED_MOVES = {"Water Spout", "Tail Slap", "Power Split", "Guard Split", "Power Swap",
                               "Guard Swap", "Magic Room", "Wonder Room"}


# --------------------------------------------------------------------------------------------
# helpers

def rel(path):
    return os.path.relpath(path, ROOT).replace(os.sep, "/")


def read_text(path):
    with open(path, "rb") as f:
        raw = f.read()
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw.decode("latin-1")


_listdir_cache = {}


def _listdir(d):
    if d not in _listdir_cache:
        try:
            _listdir_cache[d] = set(os.listdir(d))
        except OSError:
            _listdir_cache[d] = None
    return _listdir_cache[d]


def exists_cs(path, want=None):
    """Case-sensitive existence check (also correct on case-insensitive filesystems).
    want: None (any), 'file' or 'dir'."""
    path = os.path.normpath(os.path.abspath(path))
    if not path.startswith(ROOT):
        return os.path.exists(path)
    parts = os.path.relpath(path, ROOT).split(os.sep)
    cur = ROOT
    for p in parts:
        if p in ("", "."):
            continue
        entries = _listdir(cur)
        if entries is None or p not in entries:
            return False
        cur = os.path.join(cur, p)
    if want == "file":
        return os.path.isfile(cur)
    if want == "dir":
        return os.path.isdir(cur)
    return True


def case_insensitive_match(path):
    """Return the real-cased path if it exists ignoring case, else None."""
    path = os.path.normpath(os.path.abspath(path))
    if not path.startswith(ROOT):
        return None
    parts = os.path.relpath(path, ROOT).split(os.sep)
    cur = ROOT
    for p in parts:
        entries = _listdir(cur)
        if entries is None:
            return None
        if p in entries:
            cur = os.path.join(cur, p)
            continue
        low = [e for e in entries if e.lower() == p.lower()]
        if not low:
            return None
        cur = os.path.join(cur, low[0])
    return cur


class LineIndex:
    def __init__(self, text):
        self.nl = [i for i, c in enumerate(text) if c == "\n"]

    def line(self, offset):
        return bisect.bisect_right(self.nl, offset - 1) + 1


class Spans:
    def __init__(self, spans):
        self.spans = sorted(spans)
        self.starts = [s for s, _ in self.spans]

    def contains(self, pos):
        i = bisect.bisect_right(self.starts, pos) - 1
        return i >= 0 and self.spans[i][0] <= pos < self.spans[i][1]


def is_historical(relpath):
    return any(relpath.startswith(d) for d in HISTORICAL_DIRS) or bool(HISTORICAL_FILE_RE.search(relpath))


def iter_files(base, exts):
    for dp, dn, fn in os.walk(base):
        dn.sort()
        for f in sorted(fn):
            if f.lower().endswith(exts):
                yield os.path.join(dp, f)


# --------------------------------------------------------------------------------------------
# XML scanning (regex based so that commented-out entries and line numbers are kept)

XML_COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
XML_TAG_RE = re.compile(r"<([A-Za-z_][\w\-]*)((?:\s+[\w\-:]+\s*=\s*(?:\"[^\"]*\"|'[^']*'))*)\s*/?>", re.S)
XML_ATTR_RE = re.compile(r"([\w\-:]+)\s*=\s*(?:\"([^\"]*)\"|'([^']*)')")


class XmlTag:
    __slots__ = ("name", "attrs", "line", "commented", "offset")

    def __init__(self, name, attrs, line, commented, offset):
        self.name, self.attrs, self.line, self.commented, self.offset = name, attrs, line, commented, offset

    def get(self, key, default=None):
        for k, v in self.attrs.items():
            if k.lower() == key.lower():
                return v
        return default


_xml_cache = {}


def scan_xml(path):
    if path in _xml_cache:
        return _xml_cache[path]
    text = read_text(path)
    idx = LineIndex(text)
    comments = Spans([(m.start(), m.end()) for m in XML_COMMENT_RE.finditer(text)])
    tags = []
    for m in XML_TAG_RE.finditer(text):
        attrs = OrderedDict()
        for a in XML_ATTR_RE.finditer(m.group(2) or ""):
            attrs[a.group(1)] = a.group(2) if a.group(2) is not None else a.group(3)
        tags.append(XmlTag(m.group(1), attrs, idx.line(m.start()), comments.contains(m.start()), m.start()))
    _xml_cache[path] = (text, tags)
    return text, tags


def xml_wellformed(path):
    p = xml.parsers.expat.ParserCreate()
    try:
        with open(path, "rb") as f:
            p.ParseFile(f)
        return None
    except xml.parsers.expat.ExpatError as e:
        return "line %d: %s" % (e.lineno, xml.parsers.expat.ErrorString(e.code))


def parse_id_list(spec):
    """'1-3;7' -> [(1,3),(7,7)]"""
    out = []
    for part in re.split(r"[;,]", spec or ""):
        part = part.strip()
        if not part:
            continue
        m = re.match(r"^(\d+)\s*-\s*(\d+)$", part)
        if m:
            out.append((int(m.group(1)), int(m.group(2))))
        elif part.isdigit():
            out.append((int(part), int(part)))
    return out


# --------------------------------------------------------------------------------------------
# Lua scanning

def lua_lex(text):
    """Return (code_nc, code_ns, comment_spans).
    code_nc: comments replaced by spaces. code_ns: comments and string bodies replaced by spaces
    (quotes kept). Offsets are preserved."""
    n = len(text)
    nc = list(text)
    ns = list(text)
    spans = []
    i = 0

    def blank(lst, a, b):
        for k in range(a, b):
            if lst[k] != "\n":
                lst[k] = " "

    long_open = re.compile(r"\[(=*)\[")
    while i < n:
        c = text[i]
        if c == "-" and text.startswith("--", i):
            m = long_open.match(text, i + 2)
            if m:
                close = "]" + m.group(1) + "]"
                j = text.find(close, m.end())
                j = n if j < 0 else j + len(close)
            else:
                j = text.find("\n", i)
                j = n if j < 0 else j
            blank(nc, i, j)
            blank(ns, i, j)
            spans.append((i, j))
            i = j
        elif c in "\"'":
            j = i + 1
            while j < n and text[j] != c and text[j] != "\n":
                j += 2 if text[j] == "\\" else 1
            j = min(j + 1, n)
            blank(ns, i + 1, j - 1)
            i = j
        elif c == "[":
            m = long_open.match(text, i)
            if m:
                close = "]" + m.group(1) + "]"
                j = text.find(close, m.end())
                j = n if j < 0 else j + len(close)
                blank(ns, m.end(), max(m.end(), j - len(close)))
                i = j
            else:
                i += 1
        else:
            i += 1
    return "".join(nc), "".join(ns), Spans(spans)


class LuaFile:
    def __init__(self, path):
        self.path = path
        self.rel = rel(path)
        self.text = read_text(path)
        self.nc, self.ns, self.comments = lua_lex(self.text)
        self.idx = LineIndex(self.text)

    def line(self, off):
        return self.idx.line(off)


_lua_cache = {}


def lua_file(path):
    if path not in _lua_cache:
        _lua_cache[path] = LuaFile(path)
    return _lua_cache[path]


def match_brace(ns, start, open_c="{", close_c="}"):
    """ns[start] == open_c; return index after matching close."""
    depth = 0
    for k in range(start, len(ns)):
        ch = ns[k]
        if ch == open_c:
            depth += 1
        elif ch == close_c:
            depth -= 1
            if depth == 0:
                return k + 1
    return len(ns)


STR_RE = re.compile(r"\"((?:[^\"\\\n]|\\.)*)\"|'((?:[^'\\\n]|\\.)*)'")


def strings_in(s):
    return [m.group(1) if m.group(1) is not None else m.group(2) for m in STR_RE.finditer(s)]


def lua_table_keys(lf, table_name):
    """Keys of `NAME = { KEY = ..., }` and `NAME.KEY = ...` (comments ignored)."""
    keys = {}
    for m in re.finditer(r"(?<![\w.])%s\s*=\s*\{" % re.escape(table_name), lf.nc):
        b = m.end() - 1
        e = match_brace(lf.ns, b)
        body = lf.nc[b + 1:e - 1]
        depth = 0
        tok = re.compile(r"[{}]|\[\s*\"([^\"]+)\"\s*\]\s*=|(?<![\w.])([A-Za-z_]\w*)\s*=(?!=)")
        for t in tok.finditer(body):
            if t.group(0) == "{":
                depth += 1
            elif t.group(0) == "}":
                depth -= 1
            elif depth == 0:
                k = t.group(1) or t.group(2)
                val = re.match(r"\s*(-?\d+|\"[^\"]*\")", body[t.end():])
                keys[k] = val.group(1).strip('"') if val else None
    for m in re.finditer(r"(?<![\w.])%s\.([A-Za-z_]\w*)\s*=(?!=)\s*(-?\d+|\"[^\"]*\")?" % re.escape(table_name), lf.nc):
        keys[m.group(1)] = (m.group(2) or "").strip('"') or None
    return keys


def call_args(text, open_paren):
    """text[open_paren]=='(' -> (args list as raw strings, end)."""
    depth = 0
    args = []
    cur = []
    k = open_paren
    while k < len(text):
        ch = text[k]
        if ch in "([{":
            depth += 1
            if depth > 1:
                cur.append(ch)
        elif ch in ")]}":
            depth -= 1
            if depth == 0:
                args.append("".join(cur).strip())
                return args, k + 1
            cur.append(ch)
        elif ch == "," and depth == 1:
            args.append("".join(cur).strip())
            cur = []
        elif ch in "\"'":
            m = STR_RE.match(text, k)
            if m:
                cur.append(m.group(0))
                k = m.end()
                continue
            cur.append(ch)
        else:
            cur.append(ch)
        k += 1
    return args, k


def eval_concat(expr, env):
    """Evaluate a Lua string concatenation of literals/known globals. None if dynamic."""
    parts = []
    k = 0
    pieces = []
    cur = ""
    while k < len(expr):
        m = STR_RE.match(expr, k)
        if m:
            cur += m.group(0)
            k = m.end()
            continue
        if expr.startswith("..", k):
            pieces.append(cur.strip())
            cur = ""
            k += 2
            continue
        cur += expr[k]
        k += 1
    pieces.append(cur.strip())
    for p in pieces:
        if not p:
            return None
        m = STR_RE.fullmatch(p)
        if m:
            parts.append(m.group(1) if m.group(1) is not None else m.group(2))
        elif re.fullmatch(r"getDataDir\(\)", p):
            parts.append("data/")
        elif re.fullmatch(r"[A-Za-z_]\w*", p) and p in env and env[p] is not None:
            parts.append(env[p])
        else:
            return None
    return "".join(parts)


# --------------------------------------------------------------------------------------------
# findings

class Finding:
    def __init__(self, check, cls, file, line, target, detail, bug=""):
        self.check, self.cls, self.file, self.line = check, cls, file, line
        self.target, self.detail, self.bug = target, detail, bug
        self.note = ""
        self.count = 1
        self.where = None

    def full_detail(self, limit=12):
        if not self.where:
            return self.detail
        w = self.where if limit is None or len(self.where) <= limit else \
            self.where[:limit] + ["... +%d" % (len(self.where) - limit)]
        return "%s [in %s]" % (self.detail, ", ".join(w))

    @property
    def key(self):
        t = str(self.target)
        return "%s|%s|%s" % (self.check, self.file, t if t == t.strip() else repr(t))

    def as_dict(self):
        return OrderedDict([("check", self.check), ("class", self.cls), ("file", self.file),
                            ("line", self.line), ("target", self.target), ("detail", self.full_detail()),
                            ("note", self.note), ("bug", self.bug), ("count", self.count)])


class Report:
    def __init__(self):
        self.findings = []
        self.stats = Counter()
        self.facts = OrderedDict()
        self._dedup = {}

    dead_scripts = set()

    def add(self, check, cls, file, line, target, detail, bug="", dedup=False, group=False):
        f = Finding(check, cls, file, line, target, detail, bug)
        if group and not is_historical(file):
            f.where = ["%s:%s" % (os.path.basename(file), line)]
            f.file, f.line = os.path.dirname(file), 0
            k = f.key + "|" + f.cls
            if k in self._dedup:
                g = self._dedup[k]
                g.count += 1
                g.where.append(f.where[0])
                return g
            self._dedup[k] = f
            self.findings.append(f)
            return f
        if is_historical(file) and cls in (REAL, COMMENTED):
            f.cls = HISTORICAL
        if f.cls == REAL and file in self.dead_scripts:
            f.cls = COMMENTED
            f.note = "script is only referenced by commented-out registry entries"
        tree = next((d for d in HISTORICAL_DIRS if file.startswith(d)), None)
        if f.cls == HISTORICAL and tree:
            f.file, f.line, f.target = tree.rstrip("/"), 0, "*"
            f.detail = "historical tree, not loaded; e.g. %s:%s %s -- %s" % (file, line, target, detail)
            dedup = True
        if dedup:
            k = f.key
            if k in self._dedup:
                self._dedup[k].count += 1
                return self._dedup[k]
            self._dedup[k] = f
        self.findings.append(f)
        return f

    def ok(self, check, n=1):
        self.stats[check] += n

    def apply_overrides(self):
        for f in self.findings:
            if f.cls == REAL:
                for check, rx, impact, bug in IMPACTS:
                    if f.check == check and re.search(rx, str(f.target)):
                        f.note = impact
                        if bug:
                            f.bug = bug
                        break
            for check, rx, cls, note, bug in OVERRIDES:
                if f.check == check and re.search(rx, "%s|%s" % (f.file, f.target)):
                    f.cls = cls
                    f.note = note
                    if bug:
                        f.bug = bug
                    break


# --------------------------------------------------------------------------------------------
# reference databases

class DB:
    pass


def parse_otb(path):
    """Server ids from items.otb (OTB node tree; 0xFE start, 0xFF end, 0xFD escape)."""
    ids = set()
    with open(path, "rb") as f:
        data = f.read()
    i = 4
    stack = []
    n = len(data)
    while i < n:
        b = data[i]
        if b == 0xFE:
            stack.append(bytearray())
            i += 1
        elif b == 0xFF:
            node = stack.pop() if stack else bytearray()
            if len(stack) == 1 and len(node) >= 5:
                k = 5
                while k + 3 <= len(node):
                    attr = node[k]
                    ln = node[k + 1] | (node[k + 2] << 8)
                    payload = node[k + 3:k + 3 + ln]
                    if attr == 0x10 and ln >= 2:
                        ids.add(payload[0] | (payload[1] << 8))
                    k += 3 + ln
            i += 1
        elif b == 0xFD:
            if stack:
                stack[-1].append(data[i + 1])
            i += 2
        else:
            if stack:
                stack[-1].append(b)
            i += 1
    return ids


def build_db(rep):
    db = DB()
    # items
    db.items_xml = set()
    db.item_names = {}
    _, tags = scan_xml(os.path.join(DATA, "items", "items.xml"))
    for t in tags:
        if t.name != "item" or t.commented:
            continue
        if t.get("id") and t.get("id").isdigit():
            db.items_xml.add(int(t.get("id")))
            db.item_names[int(t.get("id"))] = t.get("name", "")
        elif t.get("fromid") and t.get("toid"):
            for k in range(int(t.get("fromid")), int(t.get("toid")) + 1):
                db.items_xml.add(k)
                db.item_names[k] = t.get("name", "")
    otb = os.path.join(DATA, "items", "items.otb")
    db.items_otb = parse_otb(otb) if os.path.exists(otb) else set()
    rep.facts["items.xml ids"] = len(db.items_xml)
    rep.facts["items.otb server ids"] = len(db.items_otb)

    # monsters
    db.monsters = {}
    db.monster_files = {}
    mx = os.path.join(DATA, "monster", "monsters.xml")
    _, tags = scan_xml(mx)
    db.monsters_commented = {}
    for t in tags:
        if t.name != "monster" or not t.get("name"):
            continue
        if t.commented:
            db.monsters_commented[t.get("name").lower()] = t
        else:
            db.monsters[t.get("name").lower()] = t
    rep.facts["monsters.xml entries"] = len(db.monsters)

    # NPC files
    db.npc_files = {f[:-4] for f in os.listdir(os.path.join(DATA, "npc")) if f.endswith(".xml")}

    # spells (names)
    db.spells = set()
    _, tags = scan_xml(os.path.join(DATA, "spells", "spells.xml"))
    for t in tags:
        if t.name.lower() in ("instant", "rune", "conjure") and not t.commented and t.get("name"):
            db.spells.add(t.get("name").lower())
    src = read_text(os.path.join(SERVER, "src", "monsters.cpp"))
    db.builtin_attacks = set(re.findall(r'tmpName == "([a-z]+)"', src))

    # creature events
    db.creature_events = {}
    _, tags = scan_xml(os.path.join(DATA, "creaturescripts", "creaturescripts.xml"))
    for t in tags:
        if t.name.lower() in EVENT_SUBSYSTEMS["creaturescripts"] and t.get("name"):
            db.creature_events.setdefault(t.get("name"), []).append(t)

    # raids
    db.raids = {}
    _, tags = scan_xml(os.path.join(DATA, "raids", "raids.xml"))
    for t in tags:
        if t.name == "raid" and t.get("name"):
            db.raids[t.get("name").lower()] = t

    # Lua: species, moves, constant tables
    db.species = {}
    for p in iter_files(os.path.join(DATA, "lib", "ps", "config", "pokemon"), (".lua",)):
        lf = lua_file(p)
        for m in re.finditer(r'POKEMON\["([^"]+)"\]\s*=(?!=)', lf.nc):
            db.species.setdefault(m.group(1), (lf.rel, lf.line(m.start())))
    db.moves = {}
    for p in iter_files(os.path.join(DATA, "lib", "ps", "config", "moves"), (".lua",)):
        lf = lua_file(p)
        for m in re.finditer(r'MOVES\["([^"]+)"\]\s*=(?!=)', lf.nc):
            db.moves.setdefault(m.group(1), (lf.rel, lf.line(m.start())))
    skill = lua_file(os.path.join(DATA, "lib", "ps", "config", "skill.lua"))
    for m in re.finditer(r'\["([^"]+)"\]\s*=\s*\{\s*description', skill.nc):
        db.moves.setdefault(m.group(1), (skill.rel, skill.line(m.start())))
    rep.facts["species (POKEMON[...] keys, live tree)"] = len(db.species)
    rep.facts["moves (MOVES[...] keys)"] = len(db.moves)

    const = lua_file(os.path.join(DATA, "lib", "ps", "others", "constants.lua"))
    db.tm_ids = lua_table_keys(const, "TM_IDS")
    db.tm_ids_commented = set(re.findall(r"^\s*--\[\[\s*([A-Z_0-9]+)\s*=", const.text, re.M)) - set(db.tm_ids)
    db.extended_ids = {k: int(v) for k, v in lua_table_keys(const, "EXTENDED_IDS").items() if v}
    db.special_abilities = None
    db.const_tables = {}
    for name in ("TM_IDS", "POKEMON_SPECIAL_ABILITY_IDS", "POKEMON_ABILITIES", "BALL_SEAL_IDS"):
        keys = {}
        for p in iter_files(os.path.join(DATA, "lib"), (".lua",)):
            if is_historical(rel(p)):
                continue
            lf = lua_file(p)
            if re.search(r"(?<![\w.])%s(\s*=|\.\w+\s*=)" % name, lf.nc):
                keys.update(lua_table_keys(lf, name))
        db.const_tables[name] = keys
    db.ability_values = {v for v in db.const_tables["POKEMON_ABILITIES"].values() if v}
    pk = lua_file(os.path.join(DATA, "lib", "ps", "config", "pokemon.lua"))
    db.const_tables["ITEMS"] = lua_table_keys(pk, "ITEMS")

    # live spawn / house file named in the OTBM header
    db.spawn_file = db.house_file = None
    otbm = os.path.join(DATA, "world", "map.otbm")
    if os.path.exists(otbm):
        with open(otbm, "rb") as f:
            head = f.read(8192)
        names = [x.decode("latin-1") for x in re.findall(rb"[\w\- .]+\.xml", head)]
        db.spawn_file = next((x for x in names if "spawn" in x), None)
        db.house_file = next((x for x in names if "house" in x), None)
    rep.facts["map.otbm spawn file"] = db.spawn_file
    rep.facts["map.otbm house file"] = db.house_file

    # Lua scripts referenced only by commented-out registry entries
    live, dead = set(), set()
    for sub, nodes in EVENT_SUBSYSTEMS.items():
        xp = os.path.join(DATA, sub, sub + ".xml")
        if not os.path.exists(xp):
            continue
        for t in scan_xml(xp)[1]:
            if t.name.lower() not in nodes:
                continue
            s = t.get("value") if (t.get("event") or "").lower() == "script" else t.get("script")
            if not s:
                continue
            r = rel(os.path.normpath(os.path.join(DATA, sub, "scripts", s)))
            (dead if t.commented else live).add(r)
    for p in iter_files(os.path.join(DATA, "npc"), (".xml",)):
        for t in scan_xml(p)[1]:
            if t.name == "npc" and t.get("script") and "/" not in t.get("script"):
                live.add(rel(os.path.join(DATA, "npc", "scripts", t.get("script"))))
    db.live_scripts = live
    rep.dead_scripts = dead - live
    rep.facts["registry scripts referenced only from commented entries"] = len(rep.dead_scripts)

    # global string vars for dofile resolution
    db.lua_env = {}
    defs = []
    for p in iter_files(DATA, (".lua",)):
        lf = lua_file(p)
        for m in re.finditer(r"^[ \t]*([A-Z_][A-Za-z0-9_]*)[ \t]*=(?!=)[ \t]*([^\n]+)$", lf.nc, re.M):
            defs.append((m.group(1), m.group(2).strip()))
    for _ in range(4):
        for k, v in defs:
            val = eval_concat(v, db.lua_env)
            if val is not None:
                db.lua_env.setdefault(k, val)
    return db


def near_match(word, candidates):
    cands = list(candidates)
    low = {c.lower().strip(): c for c in cands}
    if word.lower().strip() in low:
        return low[word.lower().strip()]
    m = difflib.get_close_matches(word, cands, n=1, cutoff=0.84)
    return m[0] if m else None


def item_known(db, iid):
    return iid in db.items_xml or iid in db.items_otb


def item_problem(db, iid):
    if iid == 0:
        return None
    if iid in db.items_xml:
        return None
    if iid in db.items_otb:
        return "otb-only"
    return "missing"


# --------------------------------------------------------------------------------------------
# server checks

def check_event_registries(rep, db):
    for sub, nodes in EVENT_SUBSYSTEMS.items():
        xml_path = os.path.join(DATA, sub, sub + ".xml")
        if not os.path.exists(xml_path):
            continue
        err = xml_wellformed(xml_path)
        if err:
            rep.add("xml.wellformed", REAL, rel(xml_path), 0, sub + ".xml", "malformed XML: " + err)
        base = os.path.join(DATA, sub, "scripts")
        _, tags = scan_xml(xml_path)
        for t in tags:
            if t.name.lower() not in nodes:
                continue
            script = None
            if (t.get("event") or "").lower() == "script":
                script = t.get("value")
            elif t.get("script") and t.get("script").lower() != "cdata":
                script = t.get("script")
            if script:
                target = os.path.join(base, script)
                if exists_cs(target, "file"):
                    rep.ok("xml.script")
                else:
                    ci = case_insensitive_match(target)
                    detail = "%s <%s> script does not exist: %s" % (sub, t.name, rel(target))
                    if ci:
                        detail += " (exists with different case: %s)" % rel(ci)
                    rep.add("xml.script", COMMENTED if t.commented else REAL, rel(xml_path), t.line,
                            script, detail)
            if sub in ("actions", "movements"):
                for attr in ("itemid", "fromid"):
                    spec = t.get(attr)
                    if not spec:
                        continue
                    ranges = parse_id_list(spec)
                    if attr == "fromid" and t.get("toid", "").isdigit():
                        ranges = [(int(spec), int(t.get("toid")))] if spec.isdigit() else ranges
                    for a, b in ranges:
                        miss = [k for k in range(a, b + 1) if item_problem(db, k) == "missing"]
                        otb_only = [k for k in range(a, b + 1) if item_problem(db, k) == "otb-only"]
                        rep.ok("xml.itemid", (b - a + 1) - len(miss) - len(otb_only))
                        if miss:
                            rep.add("xml.itemid", COMMENTED if t.commented else REAL, rel(xml_path), t.line,
                                    "%d-%d" % (a, b) if a != b else str(a),
                                    "%s itemid not in items.xml nor items.otb: %s" % (sub, compress_ids(miss)))
                        if otb_only:
                            rep.add("xml.itemid.otbonly", COMMENTED if t.commented else FALSE_POSITIVE,
                                    rel(xml_path), t.line, "%d-%d" % (a, b) if a != b else str(a),
                                    "%s itemid only in items.otb (no items.xml entry, engine still knows it): %s"
                                    % (sub, compress_ids(otb_only)))
        # lib dirs are loaded with loadDirectory (non-recursive)
        rep.facts["%s/lib loaded files" % sub] = len([f for f in os.listdir(os.path.join(DATA, sub, "lib"))
                                                      if f.endswith(".lua")]) if os.path.isdir(os.path.join(DATA, sub, "lib")) else 0


def compress_ids(ids):
    ids = sorted(set(ids))
    out = []
    start = prev = None
    for k in ids:
        if start is None:
            start = prev = k
        elif k == prev + 1:
            prev = k
        else:
            out.append("%d-%d" % (start, prev) if start != prev else str(start))
            start = prev = k
    if start is not None:
        out.append("%d-%d" % (start, prev) if start != prev else str(start))
    s = ";".join(out)
    return s if len(s) < 200 else s[:200] + "..."


def check_raids(rep, db):
    raids_xml = os.path.join(DATA, "raids", "raids.xml")
    _, tags = scan_xml(raids_xml)
    for t in tags:
        if t.name != "raid":
            continue
        f = t.get("file") or (t.get("name", "") + ".xml")
        target = os.path.join(DATA, "raids", f)
        disabled = t.commented or (t.get("enabled") or "yes").lower() in ("no", "0", "false")
        if not exists_cs(target, "file"):
            rep.add("raid.file", COMMENTED if t.commented else REAL, rel(raids_xml), t.line, f,
                    "raid file missing: " + rel(target))
            continue
        rep.ok("raid.file")
        err = xml_wellformed(target)
        if err:
            rep.add("xml.wellformed", COMMENTED if t.commented else REAL, rel(target), 0, f, "malformed raid XML: " + err)
        _, rtags = scan_xml(target)
        for rt in rtags:
            if rt.name in ("monster", "singlespawn") and rt.get("name"):
                if rt.get("name").lower() in db.monsters:
                    rep.ok("raid.monster")
                else:
                    cls = COMMENTED if (t.commented or rt.commented) else REAL
                    rep.add("raid.monster", cls, rel(target), rt.line, rt.get("name"),
                            "raid monster not in monsters.xml (raid '%s'%s)"
                            % (t.get("name"), ", commented in raids.xml" if t.commented else ""), dedup=True)
            if rt.name == "script" and rt.get("file"):
                st = os.path.join(DATA, "raids", "scripts", rt.get("file"))
                if not exists_cs(st, "file"):
                    rep.add("raid.script", COMMENTED if (t.commented or rt.commented) else REAL, rel(target),
                            rt.line, rt.get("file"), "raid script missing: " + rel(st))
                else:
                    rep.ok("raid.script")
        rep.facts.setdefault("raids (active/disabled/commented)", Counter())[
            "commented" if t.commented else ("disabled" if disabled else "active")] += 1
    # raid xml files not referenced
    referenced = {os.path.normpath(os.path.join(DATA, "raids", t.get("file"))) for t in tags
                  if t.name == "raid" and t.get("file")}
    for p in iter_files(os.path.join(DATA, "raids"), (".xml",)):
        if os.path.basename(p) in ("raids.xml",) or os.path.normpath(p) in referenced:
            continue
        rep.facts.setdefault("raid XML files not referenced by raids.xml", []).append(rel(p))


def check_npcs(rep, db):
    npc_dir = os.path.join(DATA, "npc")
    for p in iter_files(npc_dir, (".xml",)):
        r = rel(p)
        if "/npc/lib/" in r:
            continue
        name = os.path.basename(p)
        if name.startswith("tmpCitizen_"):
            rep.ok("npc.tmpCitizen")
            continue
        err = xml_wellformed(p)
        if err:
            rep.add("xml.wellformed", REAL, r, 0, name, "malformed NPC XML: " + err)
        _, tags = scan_xml(p)
        for t in tags:
            if t.name == "npc" and t.get("script"):
                s = t.get("script")
                target = os.path.join(npc_dir, "scripts", s) if "/" not in s else os.path.join(SERVER, s)
                if exists_cs(target, "file"):
                    rep.ok("npc.script")
                else:
                    rep.add("npc.script", COMMENTED if t.commented else REAL, r, t.line, s,
                            "NPC script missing: " + rel(target))
            if t.name == "parameter" and (t.get("key") or "").lower() in ("shop_buyable", "shop_sellable"):
                for entry in (t.get("value") or "").split(";"):
                    parts = [x.strip() for x in entry.split(",")]
                    if len(parts) >= 2 and parts[1].isdigit():
                        prob = item_problem(db, int(parts[1]))
                        if prob == "missing":
                            rep.add("npc.shop.itemid", COMMENTED if t.commented else REAL, r, t.line, parts[1],
                                    "NPC shop item '%s' id %s not in items.xml/otb" % (parts[0], parts[1]))
                        else:
                            rep.ok("npc.shop.itemid")
    # NPC Lua configs with item ids are not parsed (too many ad-hoc formats)


def check_monsters(rep, db):
    mon_dir = os.path.join(DATA, "monster")
    mx = os.path.join(mon_dir, "monsters.xml")
    registered = set()
    for name, t in list(db.monsters.items()) + list(db.monsters_commented.items()):
        f = os.path.join(mon_dir, t.get("file") or "")
        if not exists_cs(f, "file"):
            ci = case_insensitive_match(f)
            rep.add("monsters.xml.file", COMMENTED if t.commented else REAL, rel(mx), t.line, t.get("file"),
                    "monster file missing for '%s'%s" % (t.get("name"), " (case differs: %s)" % rel(ci) if ci else ""))
            continue
        rep.ok("monsters.xml.file")
        if t.commented:
            continue
        registered.add(os.path.normpath(f))
    dup = Counter(t.get("name").lower() for t in scan_xml(mx)[1] if t.name == "monster" and not t.commented and t.get("name"))
    for n, c in dup.items():
        if c > 1:
            rep.add("monsters.xml.duplicate", FALSE_POSITIVE, rel(mx), db.monsters[n].line, n,
                    "monster name registered %d times (last wins in the map)" % c)
    orphans = [rel(p) for p in iter_files(mon_dir, (".xml",))
               if os.path.normpath(p) not in registered and not p.endswith("monsters.xml")]
    rep.facts["monster XML files not registered in monsters.xml"] = len(orphans)
    for p in sorted(registered):
        r = rel(p)
        err = xml_wellformed(p)
        if err:
            rep.add("xml.wellformed", REAL, r, 0, os.path.basename(p), "malformed monster XML (not loaded): " + err)
        _, tags = scan_xml(p)
        for t in tags:
            if t.commented:
                continue
            if t.name == "item" and t.get("id", "").isdigit():
                prob = item_problem(db, int(t.get("id")))
                if prob == "missing":
                    rep.add("monster.loot", REAL, r, t.line, t.get("id"), "loot item id not in items.xml/otb")
                else:
                    rep.ok("monster.loot")
            elif t.name == "summon" and t.get("name"):
                if t.get("name").lower() in db.monsters:
                    rep.ok("monster.summon")
                else:
                    rep.add("monster.summon", REAL, r, t.line, t.get("name"), "summon not in monsters.xml")
            elif t.name in ("attack", "defense") and t.get("name"):
                n = t.get("name").lower()
                if n in db.spells or n in db.builtin_attacks:
                    rep.ok("monster.spell")
                else:
                    rep.add("monster.spell", REAL, r, t.line, t.get("name"),
                            "<%s name> is neither a spells.xml spell nor a built-in attack" % t.name, dedup=False)
            elif t.name == "event" and t.get("name"):
                if t.get("name") in db.creature_events:
                    rep.ok("monster.event")
                else:
                    rep.add("monster.event", REAL, r, t.line, t.get("name"),
                            "monster <script><event> not in creaturescripts.xml (case-sensitive)")


def check_spawns(rep, db):
    world = os.path.join(DATA, "world")
    files = [f for f in os.listdir(world) if f.endswith("spawn.xml")]
    for f in sorted(files):
        path = os.path.join(world, f)
        live = f == db.spawn_file
        _, tags = scan_xml(path)
        for t in tags:
            nm = t.get("name")
            if not nm:
                continue
            if t.name == "monster":
                if nm.lower() in db.monsters:
                    rep.ok("spawn.monster")
                    continue
                cls = REAL if live else HISTORICAL
                if t.commented:
                    cls = COMMENTED
                extra = " (commented out in monsters.xml)" if nm.lower() in db.monsters_commented else ""
                rep.add("spawn.monster", cls, rel(path), t.line, nm, "spawned monster not in monsters.xml" + extra,
                        dedup=True)
            elif t.name == "npc":
                if nm in db.npc_files:
                    rep.ok("spawn.npc")
                    continue
                if nm.startswith("tmpCitizen_"):
                    rep.add("spawn.npc", FALSE_POSITIVE, rel(path), t.line, nm, "tmpCitizen_* regenerated at startup",
                            dedup=True)
                    continue
                ci = [x for x in db.npc_files if x.lower() == nm.lower()]
                cls = REAL if live else HISTORICAL
                if t.commented:
                    cls = COMMENTED
                rep.add("spawn.npc", cls, rel(path), t.line, nm,
                        "spawned NPC has no data/npc/<name>.xml" + (" (case differs: %s.xml)" % ci[0] if ci else ""),
                        dedup=True)
    rep.facts["spawn files present"] = files
    house_files = [f for f in os.listdir(world) if f.endswith("house.xml")]
    rep.facts["house files present"] = house_files


LUA_LOADERS = re.compile(r"(?<![\w.:])(dofile|dodirectory|loadfile|require)\s*\(")


def server_lua_files():
    return list(iter_files(DATA, (".lua",)))


def check_server_lua(rep, db):
    raid_calls = re.compile(r"(?<![\w.:])(executeRaid|doExecuteRaid)\s*\(")
    npc_calls = re.compile(r"(?<![\w.:])doCreateNpc\s*\(")
    mon_calls = re.compile(r"(?<![\w.:])(doCreateMonster|doSummonCreature|doSummonMonster|doCreatureSummonCreature)\s*\(")
    ev_calls = re.compile(r"(?<![\w.:])(registerCreatureEvent|unregisterCreatureEvent)\s*\(")
    for p in server_lua_files():
        lf = lua_file(p)
        r = lf.rel
        hist = is_historical(r)
        for m in LUA_LOADERS.finditer(lf.text):
            if re.search(r"function\s*$", lf.text[max(0, m.start() - 12):m.start()]):
                continue
            commented = lf.comments.contains(m.start())
            args, _ = call_args(lf.text, m.end() - 1)
            if not args or not args[0]:
                continue
            val = eval_concat(args[0], db.lua_env)
            line = lf.line(m.start())
            if val is None:
                rep.add("lua.loader", COMMENTED if commented else FALSE_POSITIVE, r, line, args[0],
                        "%s path built at runtime, not statically resolvable" % m.group(1))
                continue
            target = os.path.join(SERVER, val)
            want = "dir" if m.group(1) == "dodirectory" else "file"
            if m.group(1) == "require":
                target = os.path.join(SERVER, val.replace(".", "/") + ".lua")
            if exists_cs(target, want):
                rep.ok("lua.loader")
            else:
                rep.add("lua.loader", COMMENTED if commented else REAL, r, line, val,
                        "%s target does not exist: %s" % (m.group(1), rel(target)))
        if hist:
            continue
        for rx, check, resolver in ((raid_calls, "lua.executeRaid", "raid"), (npc_calls, "lua.doCreateNpc", "npc"),
                                     (mon_calls, "lua.createMonster", "monster"), (ev_calls, "lua.creatureEvent", "event")):
            for m in rx.finditer(lf.text):
                if re.search(r"function\s*$", lf.text[max(0, m.start() - 12):m.start()]):
                    continue
                args, _ = call_args(lf.text, m.end() - 1)
                argi = 1 if resolver == "event" else 0
                if len(args) <= argi:
                    continue
                sm = STR_RE.fullmatch(args[argi])
                if not sm:
                    continue
                name = sm.group(1) if sm.group(1) is not None else sm.group(2)
                commented = lf.comments.contains(m.start())
                line = lf.line(m.start())
                if resolver == "raid":
                    t = db.raids.get(name.lower())
                    if t is None:
                        rep.add(check, COMMENTED if commented else REAL, r, line, name, "executeRaid: no such raid in raids.xml")
                    elif t.commented:
                        rep.add(check, COMMENTED if commented else REAL, r, line, name,
                                "executeRaid: raid is commented out in raids.xml:%d (call returns false)" % t.line)
                    else:
                        rep.ok(check)
                elif resolver == "npc":
                    if name in db.npc_files:
                        rep.ok(check)
                    else:
                        rep.add(check, COMMENTED if commented else REAL, r, line, name, "doCreateNpc: no data/npc/<name>.xml")
                elif resolver == "monster":
                    if name.lower() in db.monsters:
                        rep.ok(check)
                    else:
                        rep.add(check, COMMENTED if commented else REAL, r, line, name, "%s: monster not in monsters.xml" % m.group(1))
                else:
                    if name in db.creature_events:
                        rep.ok(check)
                    else:
                        ci = [k for k in db.creature_events if k.lower() == name.lower()]
                        rep.add(check, COMMENTED if commented else REAL, r, line, name,
                                "%s: no creaturescripts.xml event with this name%s" % (
                                    m.group(1), " (case differs: %s)" % ci[0] if ci else ""))


def check_pokemon_configs(rep, db):
    pdir = os.path.join(DATA, "lib", "ps", "config", "pokemon")
    trees = [(pdir, False),
             (os.path.join(DATA, "lib", "ps", "config", "_pokemon"), True),
             (os.path.join(DATA, "lib", "ps", "others", "pokemon_backup"), True)]
    tm_keys = set(db.const_tables["TM_IDS"])
    sa_keys = set(db.const_tables["POKEMON_SPECIAL_ABILITY_IDS"])
    ab_keys = set(db.const_tables["POKEMON_ABILITIES"])
    item_keys = db.const_tables["ITEMS"]
    for base, hist in trees:
        if not os.path.isdir(base):
            continue
        for p in iter_files(base, (".lua",)):
            lf = lua_file(p)
            r = lf.rel

            def add(check, line, target, detail, off, dedup=False):
                commented = lf.comments.contains(off)
                cls = HISTORICAL if hist else (COMMENTED if commented else REAL)
                return rep.add(check, cls, r, line, target, detail, group=True)

            for m in re.finditer(r"\bevolutions\s*=\s*\{", lf.nc):
                b = m.end() - 1
                e = match_brace(lf.ns, b)
                for nm in re.finditer(r'\bname\s*=\s*"([^"]+)"', lf.nc[b:e]):
                    off = b + nm.start()
                    if nm.group(1) in db.species:
                        rep.ok("pokemon.evolution")
                    else:
                        ci = [s for s in db.species if s.lower() == nm.group(1).lower()]
                        add("pokemon.evolution", lf.line(off), nm.group(1),
                            "evolution target is not a POKEMON[...] species" + (" (case differs: %s)" % ci[0] if ci else ""), off)
                for it in re.finditer(r"ITEMS\.([A-Z_0-9]+)", lf.nc[b:e]):
                    off = b + it.start()
                    if it.group(1) not in item_keys:
                        add("pokemon.evolution.item", lf.line(off), "ITEMS." + it.group(1), "ITEMS key undefined (nil item)", off)
                    elif item_keys[it.group(1)] and item_problem(db, int(item_keys[it.group(1)])) == "missing":
                        add("pokemon.evolution.item", lf.line(off), "ITEMS." + it.group(1),
                            "evolution item id %s not in items.xml/otb" % item_keys[it.group(1)], off, dedup=True)
                    else:
                        rep.ok("pokemon.evolution.item")
            for fld in ("skills", "eggMoves"):
                for m in re.finditer(r"\b%s\s*=\s*\{" % fld, lf.nc):
                    b = m.end() - 1
                    e = match_brace(lf.ns, b)
                    for sm in STR_RE.finditer(lf.nc[b:e]):
                        mv = sm.group(1) if sm.group(1) is not None else sm.group(2)
                        off = b + sm.start()
                        if mv in db.moves:
                            rep.ok("pokemon.move")
                            continue
                        near = None if mv in GENUINE_UNIMPLEMENTED_MOVES else near_match(mv, db.moves)
                        if fld == "skills":
                            add("pokemon.move", lf.line(off), mv, "skills entry is not a MOVES[...] move%s" % (
                                " (did you mean %r?)" % near if near else ""), off)
                        elif near:
                            add("pokemon.eggMove.typo", lf.line(off), mv,
                                "eggMoves typo of %r; doUpdatePokemonEggMovesList() silently drops it" % near, off)
                        else:
                            f = add("pokemon.eggMove.unimplemented", lf.line(off), mv,
                                    "egg move not implemented; pruned at startup by design (pokemon.lua:1668)", off,
                                    dedup=True)
                            if f.cls == REAL:
                                f.cls = FALSE_POSITIVE
            for m in re.finditer(r"\babilities\s*=\s*\{", lf.nc):
                b = m.end() - 1
                e = match_brace(lf.ns, b)
                for sm in STR_RE.finditer(lf.nc[b:e]):
                    ab = sm.group(1) if sm.group(1) is not None else sm.group(2)
                    off = b + sm.start()
                    if ab in db.ability_values:
                        rep.ok("pokemon.ability")
                    else:
                        near = near_match(ab, db.ability_values)
                        f = add("pokemon.ability", lf.line(off), ab, "ability string matches no POKEMON_ABILITIES "
                                "value%s; the field ability is never granted" % (" (typo of %r?)" % near if near else ""), off)
                        if ab == "Strenght":
                            f.bug = "BUG-30"
            for tbl, keys, check in (("TM_IDS", tm_keys, "pokemon.tm"),
                                      ("POKEMON_SPECIAL_ABILITY_IDS", sa_keys, "pokemon.specialAbility"),
                                      ("POKEMON_ABILITIES", ab_keys, "pokemon.ability")):
                for m in re.finditer(r"\b%s\.([A-Za-z_0-9]+)" % tbl, lf.text):
                    key = m.group(1)
                    if key in keys:
                        rep.ok(check)
                        continue
                    tgt = "%s.%s" % (tbl, key)
                    near = near_match(key, keys)
                    if tbl == "TM_IDS" and key in db.tm_ids_commented:
                        f = add(check, lf.line(m.start()), tgt, "TM_IDS key is commented out in constants.lua "
                                "(TM disabled) -> nil entry", m.start(), dedup=True)
                        if f.cls == REAL:
                            f.cls = COMMENTED
                    elif near:
                        add(check, lf.line(m.start()), tgt, "%s key undefined (typo of %s?) -> nil, species "
                            "cannot use it" % (tbl, near), m.start())
                    elif tbl == "TM_IDS" and key.replace("_", " ").title() in db.moves:
                        f = add(check, lf.line(m.start()), tgt, "no TM exists for this move (not in TM_IDS nor TMS); "
                                "nil entry has no effect", m.start(), dedup=True)
                        if f.cls == REAL:
                            f.cls = FALSE_POSITIVE
                    else:
                        add(check, lf.line(m.start()), tgt, "%s key undefined -> nil (stray token, intended "
                            "value unknown)" % tbl, m.start())
            for m in re.finditer(r"\b(eggId|portrait|dexPortrait|fastcallPortrait)\s*=\s*(\d+)", lf.nc):
                iid = int(m.group(2))
                prob = item_problem(db, iid)
                if prob == "missing":
                    add("pokemon.itemid", lf.line(m.start()), m.group(2), "%s item id not in items.xml/otb" % m.group(1), m.start())
                elif prob == "otb-only":
                    rep.ok("pokemon.itemid.otbonly")
                else:
                    rep.ok("pokemon.itemid")


def check_moves_and_tms(rep, db):
    tm_keys = set(db.const_tables["TM_IDS"])
    for p in server_lua_files():
        lf = lua_file(p)
        if "/config/pokemon/" in lf.rel or "/config/_pokemon/" in lf.rel or "/pokemon_backup/" in lf.rel:
            continue
        for m in re.finditer(r"\bTM_IDS\.([A-Za-z_0-9]+)", lf.text):
            if m.group(1) in tm_keys:
                rep.ok("lua.tm")
            else:
                rep.add("lua.tm", COMMENTED if lf.comments.contains(m.start()) else REAL, lf.rel, lf.line(m.start()),
                        "TM_IDS." + m.group(1), "TM_IDS key undefined", dedup=True)
    tmf = lua_file(os.path.join(DATA, "lib", "ps", "systems", "018-technicalMachine.lua"))
    for m in re.finditer(r"\bmove\s*=\s*\"([^\"]+)\"", tmf.text):
        if m.group(1) in db.moves:
            rep.ok("tm.move")
        else:
            rep.add("tm.move", COMMENTED if tmf.comments.contains(m.start()) else REAL, tmf.rel, tmf.line(m.start()),
                    m.group(1), "TMS[...].move is not a MOVES[...] move")
    for m in re.finditer(r"\bitemid\s*=\s*(\d+)", tmf.nc):
        if item_problem(db, int(m.group(1))) == "missing":
            rep.add("tm.itemid", REAL, tmf.rel, tmf.line(m.start()), m.group(1), "TM item id not in items.xml/otb")
        else:
            rep.ok("tm.itemid")
    for p in iter_files(os.path.join(DATA, "lib", "ps", "config", "moves"), (".lua",)):
        lf = lua_file(p)
        for m in re.finditer(r"\biconId\s*=\s*(\d+)", lf.nc):
            prob = item_problem(db, int(m.group(1)))
            if prob == "missing" and m.group(1) != "0":
                rep.add("move.iconId", CLIENT_DEP, lf.rel, lf.line(m.start()), m.group(1),
                        "move iconId not a server item id (only used as a client sprite/icon)")
            else:
                rep.ok("move.iconId")


def check_quests(rep, db):
    qf = lua_file(os.path.join(DATA, "lib", "ps", "config", "003-quest.lua"))
    m = re.search(r"\bQUESTS_CONFIG\s*=\s*\{", qf.nc)
    if not m:
        return
    b = m.end() - 1
    e = match_brace(qf.ns, b)
    live_spawn_npcs = set()
    if db.spawn_file:
        for t in scan_xml(os.path.join(DATA, "world", db.spawn_file))[1]:
            if t.name == "npc" and not t.commented and t.get("name"):
                live_spawn_npcs.add(t.get("name"))
    created_npcs = {}
    for p in server_lua_files():
        lf = lua_file(p)
        if is_historical(lf.rel) or "doCreateNpc" not in lf.nc or lf.rel == qf.rel:
            continue
        for s in STR_RE.finditer(lf.nc):
            v = s.group(1) if s.group(1) is not None else s.group(2)
            if v in db.npc_files:
                created_npcs.setdefault(v, "%s:%d" % (lf.rel, lf.line(s.start())))
    k = b + 1
    while k < e - 1:
        km = re.compile(r"\[\s*\"([^\"]+)\"\s*\]\s*=\s*\{").search(qf.nc, k, e)
        if not km:
            break
        nb = km.end() - 1
        ne = match_brace(qf.ns, nb)
        npc = km.group(1)
        line = qf.line(km.start())
        commented = qf.comments.contains(km.start())
        if npc not in db.npc_files:
            ci = [x for x in db.npc_files if x.lower() == npc.lower()]
            rep.add("quest.npc", COMMENTED if commented else REAL, qf.rel, line, npc,
                    "QUESTS_CONFIG key has no data/npc/<name>.xml" + (" (case differs: %s)" % ci[0] if ci else ""))
        else:
            rep.ok("quest.npc")
            if npc not in live_spawn_npcs and npc not in created_npcs:
                rep.add("quest.npc.unspawned", REAL, qf.rel, line, npc,
                        "quest NPC has an XML but is not in %s and no doCreateNpc script names it" % db.spawn_file)
            elif npc in created_npcs and npc not in live_spawn_npcs and \
                    created_npcs[npc].split(":")[0] in rep.dead_scripts:
                rep.add("quest.npc.unspawned", COMMENTED, qf.rel, line, npc,
                        "quest NPC only created by %s, which is registered only in a commented-out entry"
                        % created_npcs[npc])
            elif npc in created_npcs:
                rep.ok("quest.npc.scriptSpawned")
        block = qf.nc[nb:ne]
        for qm in re.finditer(r"questType\s*=\s*QUEST_TYPE\.([A-Z_]+)", block):
            pass
        # per quest entry: questType followed by questRequest
        for qm in re.finditer(r"questType\s*=\s*QUEST_TYPE\.([A-Z_]+)\s*,[^\n]*\n\s*questRequest\s*=\s*(\{[^{}]*\}|\"[^\"]*\"|\d+)", block):
            qtype, req = qm.group(1), qm.group(2)
            off = nb + qm.start(2)
            ln = qf.line(off)
            if qtype == "BRING_ITEMS":
                nums = [int(x) for x in re.findall(r"-?\d+", req)]
                for iid in nums[0::2]:
                    if item_problem(db, iid) == "missing":
                        rep.add("quest.itemid", REAL, qf.rel, ln, str(iid), "BRING_ITEMS id not in items.xml/otb (NPC %s)" % npc)
                    else:
                        rep.ok("quest.itemid")
            elif qtype in ("DEFEAT_POKEMON", "CATCH_POKEMON", "BRING_POKEMON"):
                names = strings_in(req)
                for nm in names:
                    ok_species = nm in db.species
                    ok_monster = nm.lower() in db.monsters
                    if (qtype == "DEFEAT_POKEMON" and ok_monster) or (qtype != "DEFEAT_POKEMON" and ok_species):
                        rep.ok("quest.pokemon")
                    else:
                        rep.add("quest.pokemon", REAL, qf.rel, ln, nm, "%s target '%s' is not a %s (NPC %s)" % (
                            qtype, nm, "monsters.xml monster" if qtype == "DEFEAT_POKEMON" else "POKEMON species", npc))
        for rm in re.finditer(r"type\s*=\s*REWARD_TYPE\.ITEM\s*,\s*id\s*=\s*(\d+)", block):
            iid = int(rm.group(1))
            if item_problem(db, iid) == "missing":
                rep.add("quest.reward", REAL, qf.rel, qf.line(nb + rm.start()), str(iid),
                        "reward item id not in items.xml/otb (NPC %s)" % npc)
            else:
                rep.ok("quest.reward")
        for rm in re.finditer(r"type\s*=\s*REWARD_TYPE\.POKEMON\s*,\s*name\s*=\s*\"([^\"]+)\"", block):
            if rm.group(1) in db.species:
                rep.ok("quest.reward")
            else:
                rep.add("quest.reward", REAL, qf.rel, qf.line(nb + rm.start()), rm.group(1),
                        "reward Pokemon is not a species (NPC %s)" % npc)
        k = ne


SQL_TABLE_RE = re.compile(r"(?<!KEY )\b(?:FROM|INTO|UPDATE|JOIN)\s+`?([A-Za-z_][\w]*)`?", re.I)
SQL_START_RE = re.compile(r"^\s*(SELECT|INSERT|UPDATE|DELETE|REPLACE)\b", re.I)
SQL_KEYWORDS = {"select", "set", "where", "values", "dual"}


def check_sql(rep, db):
    schemas = [os.path.join(SERVER, "src", "schemas", f) for f in ("mysql.sql", "psoul_extra_mysql.sql")]
    tables = set()
    for s in schemas:
        if os.path.exists(s):
            tables |= {t.lower() for t in re.findall(r"CREATE TABLE (?:IF NOT EXISTS )?`?(\w+)`?", read_text(s), re.I)}
    rep.facts["SQL tables in mysql.sql + psoul_extra_mysql.sql"] = len(tables)

    def scan(path, text, comments, line_of, is_lua):
        r = rel(path)
        for sm in STR_RE.finditer(text):
            val = sm.group(1) if sm.group(1) is not None else sm.group(2)
            if not SQL_START_RE.match(val):
                continue
            # the statement may continue in the next concatenated literal
            tail = text[sm.end():sm.end() + 400]
            joined = val + " " + " ".join(strings_in(tail.split("\n", 3)[0] if is_lua else tail.split(";", 1)[0]))
            for tm in SQL_TABLE_RE.finditer(joined):
                t = tm.group(1).lower()
                if t in SQL_KEYWORDS:
                    continue
                if t in tables:
                    rep.ok("sql.table")
                    continue
                cls = COMMENTED if comments(sm.start()) else (WEBSITE_DEP if t.startswith("z_") else REAL)
                detail = "query references table `%s`, which the shipped schemas do not create" % t
                if r.endswith("databasemanager.cpp"):
                    cls = FALSE_POSITIVE
                    detail = "schema-migration / engine-metadata query (%s), not a runtime table reference" % t
                rep.add("sql.table", cls, r, line_of(sm.start()), t, detail, dedup=True)

    for p in server_lua_files():
        lf = lua_file(p)
        if is_historical(lf.rel):
            continue
        scan(p, lf.text, lf.comments.contains, lf.line, True)
    url_re = re.compile(r"https?://[^\s\"'<>)\]]+|www\.[a-z0-9\-]+\.[a-z]{2,}[^\s\"'<>)\]]*", re.I)
    url_files = [os.path.join(SERVER, "config.lua")] + [p for p in server_lua_files() if not is_historical(rel(p))] \
        + list(iter_files(CLIENT_MODULES, (".lua", ".otui", ".otmod"))) + [os.path.join(CLIENT, "init.lua")]
    for p in url_files:
        lf = lua_file(p)
        for um in url_re.finditer(lf.text):
            u = um.group(0).rstrip(".,;")
            if p.endswith(".otmod") and re.match(r"^\s*website:", lf.text[lf.text.rfind("\n", 0, um.start()) + 1:um.start()]):
                continue
            if lf.comments.contains(um.start()):
                continue
            rep.add("website.url", WEBSITE_DEP, lf.rel,
                    lf.line(um.start()), u, "hard-coded external URL (not verifiable offline)", dedup=True)
    for p in iter_files(os.path.join(SERVER, "src"), (".cpp",)):
        text = read_text(p)
        idx = LineIndex(text)
        cspans = Spans([(m.start(), m.end()) for m in re.finditer(r"/\*.*?\*/|//[^\n]*", text, re.S)])
        scan(p, text, cspans.contains, idx.line, False)


# --------------------------------------------------------------------------------------------
# client checks

CLIENT_ROOTS = [CLIENT_MODULES, CLIENT_DATA, CLIENT]


def client_resolve(path, source_dir_virtual):
    """Return (virtual path, real path or None)."""
    if not path.startswith("/"):
        path = (source_dir_virtual.rstrip("/") + "/" + path) if source_dir_virtual else "/" + path
    path = re.sub(r"/+", "/", path)
    for root in CLIENT_ROOTS:
        cand = os.path.join(root, path.lstrip("/"))
        if exists_cs(cand):
            return path, cand
    return path, None


def client_ci(path):
    for root in CLIENT_ROOTS:
        c = case_insensitive_match(os.path.join(root, path.lstrip("/")))
        if c:
            return c
    return None


def parse_otml(path):
    """Very small OTML reader for .otmod: returns dict key -> value or list, with line numbers."""
    text = read_text(path)
    out = {}
    cur_list = None
    for i, raw in enumerate(text.splitlines(), 1):
        if not raw.strip() or raw.strip().startswith("//"):
            continue
        m = re.match(r"^(\s*)([@\w\-]+)\s*:\s*(.*)$", raw)
        if m:
            key, val = m.group(2), m.group(3).strip()
            if val.startswith("["):
                items = [x.strip() for x in val.strip("[]").split(",") if x.strip()]
                out[key] = (items, i)
                cur_list = None
            elif val == "":
                out[key] = ([], i)
                cur_list = key
            else:
                out[key] = (val, i)
                cur_list = None
            continue
        m = re.match(r"^\s*-\s*(.+)$", raw)
        if m and cur_list:
            out[cur_list][0].append(m.group(1).strip())
    return out


def client_modules():
    mods = {}
    for d in sorted(os.listdir(CLIENT_MODULES)):
        md = os.path.join(CLIENT_MODULES, d)
        if not os.path.isdir(md):
            continue
        for f in os.listdir(md):
            if f.endswith(".otmod"):
                info = parse_otml(os.path.join(md, f))
                name = info.get("name", (d, 0))[0]
                mods[name] = {"dir": md, "otmod": os.path.join(md, f), "info": info}
    return mods


def loaded_modules(mods):
    init = read_text(os.path.join(CLIENT, "init.lua"))
    loaded = set(re.findall(r"ensureModuleLoaded\(\"(\w+)\"\)", init))
    for n, m in mods.items():
        if str(m["info"].get("autoload", ("false",))[0]).lower() == "true":
            loaded.add(n)
    changed = True
    while changed:
        changed = False
        for n in list(loaded):
            if n not in mods:
                continue
            info = mods[n]["info"]
            for k in ("load-later", "dependencies"):
                for dep in info.get(k, ([], 0))[0]:
                    if dep in mods and dep not in loaded:
                        loaded.add(dep)
                        changed = True
    return loaded


CLIENT_CALLS = [
    (re.compile(r"(?<![\w])dofile\s*\("), "lua", "dofile"),
    (re.compile(r"(?<![\w])dofiles\s*\("), None, "dofiles"),
    (re.compile(r"\bimportStyle\s*\("), "otui", "importStyle"),
    (re.compile(r"\bloadUI\s*\("), "otui", "loadUI"),
    (re.compile(r"\bdisplayUI\s*\("), "otui", "displayUI"),
    (re.compile(r"\bimportFont\s*\("), "otfont", "importFont"),
    (re.compile(r"\bimportParticle\s*\("), "otps", "importParticle"),
    (re.compile(r"\bloadCursors\s*\("), "otml", "loadCursors"),
    (re.compile(r"\bsetImageSource\s*\("), "png", "setImageSource"),
    (re.compile(r"\bsetIcon\s*\("), "png", "setIcon"),
    (re.compile(r"\bplayMusic\s*\("), "ogg", "playMusic"),
    (re.compile(r"\bg_sounds\.play\s*\("), "ogg", "g_sounds.play"),
    (re.compile(r"\bsetupDefaultFont\s*\("), None, "setupDefaultFont"),
]
LITERAL_PREFIXES = ("/images/", "/sounds/", "/fonts/", "/styles/", "/cursors/", "/shaders/", "/data/", "/modules/")


def ext_guess(path, ext):
    if not ext or path.endswith("." + ext):
        return path
    if re.search(r"\.\w{2,5}$", path) and ext in ("png", "ogg"):
        return path
    return path + "." + ext


def check_client(rep, db):
    mods = client_modules()
    loaded = loaded_modules(mods)
    rep.facts["client modules (loaded/total)"] = "%d/%d" % (len(loaded & set(mods)), len(mods))
    rep.facts["client modules never loaded"] = sorted(set(mods) - loaded)

    def mod_of(path):
        r = os.path.relpath(path, CLIENT_MODULES).split(os.sep)
        return None if r[0] == ".." else r[0]

    dirname_to_mod = {os.path.basename(m["dir"]): n for n, m in mods.items()}

    def cls_for(path, commented=False):
        if commented:
            return COMMENTED
        md = mod_of(path)
        if md and dirname_to_mod.get(md) and dirname_to_mod[md] not in loaded:
            return COMMENTED
        return REAL

    # otmod
    for n, m in sorted(mods.items()):
        info, otmod = m["info"], m["otmod"]
        r = rel(otmod)
        for k in ("dependencies", "load-later"):
            vals, line = info.get(k, ([], 0))
            for dep in vals:
                if dep in mods:
                    rep.ok("client.otmod.module")
                else:
                    rep.add("client.otmod.module", cls_for(otmod), r, line, dep, "%s names an unknown module" % k)
        scripts, line = info.get("scripts", ([], 0))
        vdir = "/" + os.path.basename(m["dir"])
        defined = ""
        for s in scripts:
            vp, real = client_resolve(ext_guess(s, "lua"), vdir)
            if real:
                rep.ok("client.otmod.script")
                defined += read_text(real)
            else:
                ci = client_ci(vp)
                rep.add("client.otmod.script", cls_for(otmod), r, line, s,
                        "module script missing: %s%s" % (vp, " (case differs: %s)" % rel(ci) if ci else ""))
        for hook in ("@onLoad", "@onUnload"):
            val, hl = info.get(hook, (None, 0))
            if not val:
                continue
            fm = re.match(r"^([\w.:]+)\s*\(", val)
            if not fm:
                continue
            fn = fm.group(1)
            if re.search(r"function\s+%s\s*\(" % re.escape(fn), defined) or re.search(r"\b%s\s*=\s*function" % re.escape(fn), defined):
                rep.ok("client.otmod.hook")
            else:
                rep.add("client.otmod.hook", cls_for(otmod), r, hl, val,
                        "%s calls %s() which none of the module scripts define" % (hook, fn))

    # Lua + otui references
    for p in list(iter_files(CLIENT_MODULES, (".lua",))) + [os.path.join(CLIENT, "init.lua")]:
        lf = lua_file(p)
        r = lf.rel
        vdir = "/" + os.path.dirname(os.path.relpath(p, CLIENT_MODULES)).replace(os.sep, "/") \
            if p.startswith(CLIENT_MODULES) else ""
        seen = set()
        for rx, ext, fname in CLIENT_CALLS:
            for m in rx.finditer(lf.text):
                if re.search(r"function\s*[\w.:]*$", lf.text[max(0, m.start() - 30):m.start()]):
                    continue
                args, _ = call_args(lf.text, m.end() - 1)
                if not args or not args[0]:
                    continue
                arg = args[0]
                sm = STR_RE.fullmatch(arg)
                commented = lf.comments.contains(m.start())
                line = lf.line(m.start())
                lit = STR_RE.search(lf.text, m.end())
                if lit:
                    seen.add(lit.start())
                if not sm:
                    if any(arg.lstrip("\"'").startswith(x) for x in LITERAL_PREFIXES) or ".." in arg:
                        rep.add("client.path.dynamic", COMMENTED if commented else FALSE_POSITIVE, r, line, arg,
                                "%s path built at runtime" % fname, dedup=True)
                    continue
                val = sm.group(1) if sm.group(1) is not None else sm.group(2)
                if fname == "setupDefaultFont" or val == "":
                    continue
                if fname in ("setImageSource", "setIcon", "playMusic", "g_sounds.play") and not val.startswith("/") and "/" not in val:
                    pass
                vp, real = client_resolve(ext_guess(val, ext), vdir)
                if fname == "dofiles":
                    vp, real = client_resolve(val, vdir)
                if real:
                    rep.ok("client.path")
                else:
                    ci = client_ci(vp)
                    rep.add("client.path", cls_for(p, commented), r, line, val,
                            "%s(%r) does not resolve (%s)%s" % (fname, val, vp,
                                                                  " (case differs: %s)" % rel(ci) if ci else ""))
        for sm in STR_RE.finditer(lf.text):
            val = sm.group(1) if sm.group(1) is not None else sm.group(2)
            if not val.startswith(LITERAL_PREFIXES):
                continue
            after = lf.text[sm.end():sm.end() + 4].lstrip()
            before = lf.text[max(0, sm.start() - 4):sm.start()].rstrip()
            if after.startswith("..") or before.endswith(".."):
                continue
            if lf.ns[sm.start()] not in "\"'" or sm.start() in seen:
                continue
            commented = lf.comments.contains(sm.start())
            ext = "ogg" if val.startswith("/sounds/") else ("png" if val.startswith("/images/") else None)
            if val.endswith("/"):
                vp = val
                real = next((os.path.join(r_, val.lstrip("/")) for r_ in CLIENT_ROOTS
                             if exists_cs(os.path.join(r_, val.lstrip("/")), "dir")), None)
            else:
                vp, real = client_resolve(ext_guess(val, ext), "")
            if not real and ext is None:
                vp2, real = client_resolve(val, "")
            if real:
                rep.ok("client.literal")
            else:
                ci = client_ci(vp)
                rep.add("client.literal", cls_for(p, commented), r, lf.line(sm.start()), val,
                        "resource literal does not resolve (%s)%s" % (vp, " (case differs: %s)" % rel(ci) if ci else ""),
                        dedup=True)
    otui_keys = re.compile(r"^\s*(image-source|icon|icon-source|image|source)\s*:\s*(\S+)\s*$")
    for p in iter_files(CLIENT, (".otui", ".otml", ".otfont", ".otps", ".otmod")):
        if "/src-cpp/" in p:
            continue
        r = rel(p)
        if p.startswith(CLIENT_MODULES):
            vsrc = "/" + os.path.relpath(p, CLIENT_MODULES).replace(os.sep, "/")
        elif p.startswith(CLIENT_DATA):
            vsrc = "/" + os.path.relpath(p, CLIENT_DATA).replace(os.sep, "/")
        else:
            vsrc = "/" + os.path.relpath(p, CLIENT).replace(os.sep, "/")
        for i, line in enumerate(read_text(p).splitlines(), 1):
            if line.strip().startswith("//"):
                continue
            m = otui_keys.match(line)
            if not m:
                continue
            val = m.group(2).strip("\"'")
            if m.group(1) == "source" and not p.endswith(".otps"):
                continue
            if m.group(1) in ("icon", "image") and not ("/" in val or val.endswith(".png")):
                continue
            if val in ("none", "nil", "~"):
                continue
            vdir = vsrc.rsplit("/", 1)[0]
            vp, real = client_resolve(ext_guess(val, "png"), vdir)
            if real:
                rep.ok("client.otui")
            else:
                ci = client_ci(vp)
                rep.add("client.otui", cls_for(p), r, i, val, "%s does not resolve (%s)%s" % (
                    m.group(1), vp, " (case differs: %s)" % rel(ci) if ci else ""), dedup=True)

    # server -> client tutorial images (dynamic '/images/guide/' .. buffer)
    for p in server_lua_files():
        lf = lua_file(p)
        if is_historical(lf.rel):
            continue
        for m in re.finditer(r"doSendPlayerExtendedOpcode\s*\(\s*\w+\s*,\s*EXTENDED_IDS\.GAMEPLAY_TUTORIAL_IMAGE\s*,\s*\"([^\"]*)\"", lf.text):
            if not m.group(1):
                continue
            vp, real = client_resolve("/images/guide/" + m.group(1) + ".png", "")
            if real:
                rep.ok("client.guideImage")
            else:
                rep.add("client.guideImage", COMMENTED if lf.comments.contains(m.start()) else CLIENT_DEP, lf.rel,
                        lf.line(m.start()), m.group(1), "server tutorial image has no client file %s" % vp)
    return mods, loaded


# --------------------------------------------------------------------------------------------
# protocol checks

def cpp_enum(text, enum_name):
    m = re.search(r"enum\s+%s\b[^{]*\{(.*?)\}" % re.escape(enum_name), text, re.S)
    out = {}
    if not m:
        return out
    body = re.sub(r"//[^\n]*", "", m.group(1))
    for k, v in re.findall(r"(\w+)\s*=\s*(0x[0-9A-Fa-f]+|\d+)", body):
        out[k] = int(v, 0)
    return out


def check_protocol(rep, db, mods, loaded):
    srv = os.path.join(SERVER, "src", "protocolgame.cpp")
    stext = read_text(srv)
    slines = stext.splitlines()
    cdir = os.path.join(CLIENT, "src-cpp", "src", "client")
    codes = read_text(os.path.join(cdir, "protocolcodes.h"))
    parse = os.path.join(cdir, "protocolgameparse.cpp")
    ptext = read_text(parse)
    plines = ptext.splitlines()

    # --- 0xFF PSoul sub-opcodes
    psoul = cpp_enum(codes, "GameServerPSoulOpcodes")
    sent = defaultdict(list)
    func = None
    for i, line in enumerate(slines):
        fm = re.match(r"^\w[\w:<>\s\*&]*ProtocolGame::(\w+)\s*\(", line)
        if fm:
            func = fm.group(1)
        if re.search(r"output->AddByte\(0xFF\);", line):
            prev = "\n".join(slines[max(0, i - 3):i])
            nm = re.search(r"AddByte\((0x[0-9A-Fa-f]+|\d+)\)", slines[i + 1] if i + 1 < len(slines) else "")
            if "TRACK_MESSAGE" in prev and nm:
                sent[int(nm.group(1), 0)].append((i + 2, func))
    parsed = {}
    in_block = False
    for i, line in enumerate(plines):
        if "case Proto::GameServerPSoul :" in line or "case Proto::GameServerPSoul:" in line:
            in_block = True
            continue
        if in_block:
            m = re.search(r"case\s+Proto::(GameServerPSoul\w+)\s*:", line)
            if m and m.group(1) in psoul:
                call = re.search(r"(parse\w+)\s*\(", " ".join(plines[i:i + 4]))
                parsed[psoul[m.group(1)]] = (i + 1, m.group(1), call.group(1) if call else None)
            if re.search(r"case\s+Proto::GameServer(?!PSoul)\w+\s*:", line):
                in_block = False
    rep.facts["0xFF sub-opcodes sent by server"] = sorted(sent)
    rep.facts["0xFF sub-opcodes parsed by client"] = sorted(parsed)
    for code, places in sorted(sent.items()):
        if code in parsed:
            rep.ok("protocol.psoul", len(places))
        else:
            ln, fn = places[0]
            rep.add("protocol.psoul.unparsed", REAL, rel(srv), ln, "0x%02X" % code,
                    "server %s sends 0xFF/0x%02X; client has no case (client throws on unknown opcode)" % (fn, code))
    for code, (ln, name, call) in sorted(parsed.items()):
        if code not in sent:
            rep.add("protocol.psoul.unsent", FALSE_POSITIVE, rel(parse), ln, "0x%02X" % code,
                    "client parses %s (0x%02X) but the server never sends it (dead client code)" % (name, code))
    # Lua listeners for the PSoul parse functions
    lua_all = ""
    for n in loaded:
        if n in mods:
            for p in iter_files(mods[n]["dir"], (".lua",)):
                lua_all += lua_file(p).nc
    for code, (ln, name, call) in sorted(parsed.items()):
        if not call or code not in sent:
            continue
        fm = re.search(r"void\s+ProtocolGame::%s\s*\([^)]*\)\s*\{" % re.escape(call), ptext)
        if not fm:
            continue
        body = ptext[fm.end():match_brace(ptext, fm.end() - 1)]
        for ev in re.findall(r"callGlobalField\(\s*\"g_game\"\s*,\s*\"(\w+)\"", body):
            if re.search(r"\b%s\s*=" % ev, lua_all):
                rep.ok("protocol.psoul.listener")
            else:
                rep.add("protocol.psoul.listener", REAL, rel(parse), ptext[:fm.start()].count("\n") + 1, ev,
                        "%s fires g_game.%s but no loaded client module connects it" % (call, ev))

    # --- extended opcodes (server -> client)
    client_ext = {}
    const = os.path.join(CLIENT_MODULES, "gamelib", "const.lua")
    ctab = lua_table_keys(lua_file(const), "ExtendedIds")
    client_ext = {k: int(v) for k, v in ctab.items() if v}
    for k, v in db.extended_ids.items():
        ck = [ck for ck, cv in client_ext.items() if cv == v]
        if not ck:
            rep.add("protocol.extids.parity", CLIENT_DEP, "server/data/lib/ps/others/constants.lua", 0, "%s=%d" % (k, v),
                    "EXTENDED_IDS value has no ExtendedIds counterpart in client gamelib/const.lua")
        elif ck[0].lower().replace("_", "") != k.lower().replace("_", ""):
            rep.add("protocol.extids.parity", REAL, "server/data/lib/ps/others/constants.lua", 0, "%s=%d" % (k, v),
                    "client names value %d %s" % (v, ck[0]))
        else:
            rep.ok("protocol.extids.parity")
    handlers = {}
    client_sends = []
    for n, m in mods.items():
        for p in iter_files(m["dir"], (".lua",)):
            lf = lua_file(p)
            for mm in re.finditer(r"registerExtendedOpcode\s*\(\s*(ExtendedIds\.(\w+)|\d+)", lf.text):
                code = client_ext.get(mm.group(2)) if mm.group(2) else int(mm.group(1))
                handlers.setdefault(code, []).append((lf.rel, lf.line(mm.start()), n, lf.comments.contains(mm.start())))
            for mm in re.finditer(r"sendExtendedOpcode\s*\(\s*(ExtendedIds\.(\w+)|\d+)", lf.text):
                code = client_ext.get(mm.group(2)) if mm.group(2) else int(mm.group(1))
                client_sends.append((code, lf.rel, lf.line(mm.start()), n, lf.comments.contains(mm.start())))
    for cp in iter_files(os.path.join(CLIENT, "src-cpp", "src"), (".cpp",)):
        for i, line in enumerate(read_text(cp).splitlines(), 1):
            mm = re.search(r"(?<![:\w])sendExtendedOpcode\((\d+)\s*,", line)
            if mm:
                client_sends.append((int(mm.group(1)), rel(cp), i, None, False))
    server_sends = defaultdict(list)
    for p in server_lua_files():
        lf = lua_file(p)
        if is_historical(lf.rel):
            continue
        for mm in re.finditer(r"doSendPlayerExtendedOpcode\s*\(\s*[^,]+,\s*(EXTENDED_IDS\.(\w+)|\d+)", lf.text):
            if lf.comments.contains(mm.start()):
                continue
            code = db.extended_ids.get(mm.group(2)) if mm.group(2) else int(mm.group(1))
            server_sends[code].append((lf.rel, lf.line(mm.start())))
    for cp in iter_files(os.path.join(SERVER, "src"), (".cpp",)):
        for i, line in enumerate(read_text(cp).splitlines(), 1):
            mm = re.search(r"sendExtendedOpcode\((\d+|0x[0-9a-fA-F]+)\s*,", line)
            if mm:
                server_sends[int(mm.group(1), 0)].append((rel(cp), i))
    rep.facts["extended opcodes sent by server"] = sorted(k for k in server_sends if k is not None)
    rep.facts["extended opcodes registered by client"] = sorted(k for k in handlers if k is not None)
    for code, places in sorted(server_sends.items(), key=lambda x: (x[0] is None, x[0])):
        hs = [h for h in handlers.get(code, []) if h[2] in loaded and not h[3]]
        if hs:
            rep.ok("protocol.extopcode", len(places))
        else:
            rep.add("protocol.extopcode.unhandled", REAL, places[0][0], places[0][1], str(code),
                    "server sends extended opcode %s (%d call sites); no loaded client module registers it" % (code, len(places)))
    for code, hs in sorted(handlers.items(), key=lambda x: (x[0] is None, x[0])):
        if code in server_sends:
            continue
        for f, ln, mod, com in hs:
            check = "client.extopcode.locale" if code == 1 else "client.extopcode"
            rep.add(check, COMMENTED if (com or mod not in loaded) else FALSE_POSITIVE, f, ln, str(code),
                    "client registers extended opcode %s (module %s%s) but the server never sends it" % (
                        code, mod, "" if mod in loaded else ", never loaded"))
    # client -> server extended opcodes: only C++ Game::parsePlayerExtendedOpcode (opcode 10) and
    # creaturescripts type="extendedopcode" consume them
    gtext = read_text(os.path.join(SERVER, "src", "game.cpp"))
    gm = re.search(r"void Game::parsePlayerExtendedOpcode.*?\n\}", gtext, re.S)
    srv_handled = set(int(x) for x in re.findall(r"opcode\s*==\s*(\d+)", gm.group(0))) if gm else set()
    has_lua_ext = any((t.get("type") or "").lower() == "extendedopcode" and not t.commented
                      for t in scan_xml(os.path.join(DATA, "creaturescripts", "creaturescripts.xml"))[1])
    rep.facts["client->server extended opcodes handled by server"] = sorted(srv_handled) + (["lua"] if has_lua_ext else [])
    for code, f, ln, mod, com in client_sends:
        if code in srv_handled or has_lua_ext:
            rep.ok("protocol.extopcode.c2s")
        else:
            rep.add("client.extopcode.send", COMMENTED if com or (mod and mod not in loaded) else REAL, f, ln, str(code),
                    "client sends extended opcode %s; server has no handler (silently dropped)" % code)

    # --- client -> server main opcodes
    cops = cpp_enum(codes, "ClientOpcodes")
    send_cpp = os.path.join(cdir, "protocolgamesend.cpp")
    send_text = read_text(send_cpp)
    pm = re.search(r"void ProtocolGame::parsePacket\(.*?\n\}", stext, re.S)
    handled = set(int(x, 16) for x in re.findall(r"case\s+0x([0-9A-Fa-f]+)\s*:", pm.group(0))) if pm else set()
    login_phase = {"ClientEnterAccount", "ClientPendingGame", "ClientEnterGame"}
    seen = set()
    for i, line in enumerate(send_text.splitlines(), 1):
        mm = re.search(r"addU8\(Proto::(Client\w+)\)", line)
        if not mm or mm.group(1) in login_phase or mm.group(1) in seen:
            continue
        seen.add(mm.group(1))
        code = cops.get(mm.group(1))
        if code is None:
            continue
        if code in handled:
            rep.ok("protocol.c2s")
        else:
            rep.add("protocol.c2s.unhandled", CLIENT_DEP, rel(send_cpp), i, "%s=0x%02X" % (mm.group(1), code),
                    "client can send %s; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes)" % mm.group(1))


# --------------------------------------------------------------------------------------------
# output

def load_allowlist():
    keys = {}
    if not os.path.exists(ALLOWLIST):
        return keys
    with open(ALLOWLIST, encoding="utf-8") as f:
        for i, line in enumerate(f, 1):
            s = line.rstrip("\n")
            if not s.strip() or s.lstrip().startswith("#"):
                continue
            key = s.split("  #", 1)[0].strip()
            keys[key] = i
    return keys


def md_escape(s):
    return str(s).replace("|", "\\|").replace("\n", " ")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--strict", action="store_true", help="exit 1 if a REAL ERROR is not in the allowlist")
    ap.add_argument("--all", action="store_true", help="print every finding, not only REAL ERROR")
    ap.add_argument("--json", action="store_true", help="print findings as JSON")
    ap.add_argument("--markdown", action="store_true", help="print findings as markdown tables")
    ap.add_argument("--write-allowlist", action="store_true", help="print an allowlist for the current REAL ERRORs")
    args = ap.parse_args()

    rep = Report()
    db = build_db(rep)
    check_event_registries(rep, db)
    check_raids(rep, db)
    check_npcs(rep, db)
    check_monsters(rep, db)
    check_spawns(rep, db)
    check_server_lua(rep, db)
    check_pokemon_configs(rep, db)
    check_moves_and_tms(rep, db)
    check_quests(rep, db)
    check_sql(rep, db)
    mods, loaded = check_client(rep, db)
    check_protocol(rep, db, mods, loaded)
    rep.apply_overrides()
    rep.findings.sort(key=lambda f: (CLASSES.index(f.cls), f.check, f.file, f.line))

    allow = load_allowlist()
    by_class = Counter(f.cls for f in rep.findings)
    by_check = defaultdict(Counter)
    for f in rep.findings:
        by_check[f.check][f.cls] += 1
    new_real = [f for f in rep.findings if f.cls in STRICT_CLASSES and f.key not in allow]
    stale = sorted(set(allow) - {f.key for f in rep.findings if f.cls in STRICT_CLASSES})

    if args.write_allowlist:
        print("# Known REAL ERROR references accepted by `check_references.py --strict`.")
        print("# Format: <check>|<file>|<target>  # comment. Remove a line when the reference is fixed.")
        for f in rep.findings:
            if f.cls in STRICT_CLASSES:
                loc = "%s:%s" % (f.file, f.line) if f.line else (", ".join(f.where[:4]) + (" ..." if len(f.where) > 4 else "")
                                                                  if f.where else f.file)
                print("%s  # %s -- %s%s" % (f.key, loc, f.note or f.detail, (" [%s]" % f.bug) if f.bug else ""))
        return 0

    if args.json:
        print(json.dumps({"facts": rep.facts, "ok": rep.stats, "findings": [f.as_dict() for f in rep.findings]},
                         indent=1, default=lambda o: dict(o) if isinstance(o, Counter) else list(o)))
    elif args.markdown:
        by = defaultdict(list)
        for f in rep.findings:
            by[f.check].append(f)
        for check in sorted(by):
            print("\n#### `%s`\n" % check)
            print("| class | file:line | target | detail | note |")
            print("|---|---|---|---|---|")
            for f in by[check]:
                cnt = " (x%d)" % f.count if f.count > 1 else ""
                loc = "%s/" % f.file if f.where or not f.line else "%s:%s" % (f.file, f.line)
                print("| %s | `%s` | `%s`%s | %s | %s |" % (f.cls, loc, md_escape(f.target), cnt,
                                                         md_escape(f.full_detail(None)),
                                                         md_escape((f.note + " " + f.bug).strip())))
    else:
        print("PokeNation reference check (%s)" % ROOT)
        for k, v in rep.facts.items():
            if isinstance(v, list) and len(v) > 8:
                v = "%d entries: %s ..." % (len(v), ", ".join(map(str, v[:8])))
            elif isinstance(v, Counter):
                v = dict(v)
            print("  %-48s %s" % (k, v))
        print("\nResolved references by check: %d" % sum(rep.stats.values()))
        print("\nFindings by class:")
        for c in CLASSES:
            print("  %-20s %d" % (c, by_class.get(c, 0)))
        print("\nFindings by check:")
        for check in sorted(by_check):
            print("  %-32s %s" % (check, ", ".join("%s=%d" % (c, n) for c, n in sorted(by_check[check].items()))))
        shown = rep.findings if args.all else [f for f in rep.findings if f.cls == REAL]
        print("\n%s:" % ("All findings" if args.all else "REAL ERROR findings"))
        for f in shown:
            cnt = " (x%d)" % f.count if f.count > 1 else ""
            print("  [%s] %s %s:%s %s%s -- %s%s" % (f.cls, f.check, f.file, f.line, f.target, cnt, f.full_detail(),
                                                    (" [%s]" % f.bug) if f.bug else ""))
        print("\nAllowlist: %d entries, %d REAL ERROR findings not allowlisted, %d stale entries"
              % (len(allow), len(new_real), len(stale)))
        for s in stale:
            print("  stale allowlist entry (fixed?): %s" % s)
    if args.strict and new_real:
        for f in new_real:
            print("NOT ALLOWLISTED: %s  (%s:%s %s)" % (f.key, f.file, f.line, f.detail), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
