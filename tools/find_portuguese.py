#!/usr/bin/env python3
"""Scan Lua / XML / .loc / config files for lines that look like Brazilian Portuguese.

Usage:  tools/find_portuguese.py [paths...] [--include-comments] [--summary]

The heuristic flags a line when it contains a Portuguese-specific word (accented or the common
unaccented forms used in game scripts) inside a string literal or XML attribute. It is meant to
find PLAYER-FACING text that still needs translation; it does not try to be perfect.
Files are read as bytes and decoded as UTF-8 with a Latin-1 fallback because the original
project mixes both encodings.
"""
import os
import re
import sys

STRONG_WORDS = [
    # accented forms are unambiguous
    r"você", r"vocês", r"não", r"está", r"estão", r"será", r"são", r"então", r"também", r"já",
    r"até", r"após", r"é ", r"nível", r"níveis", r"missão", r"missões", r"informação", r"informações",
    r"botão", r"começar", r"mínimo", r"mágica", r"pokémon selvagem", r"obrigad[oa]", r"atenção",
    r"próxim[oa]", r"últim[oa]", r"experiência", r"evolução", r"evoluir", r"captur(ar|ou|ado|a)\b",
    r"ção\b", r"ções\b", r"ã[oe]s?\b",
    # frequent unaccented forms in this code base
    r"\bvoce\b", r"\bnao\b", r"\bpode\b", r"\bprecisa\b", r"\bprecisar[aá]\b", r"\bjogador(es|a)?\b",
    r"\bainda\b", r"\btambem\b", r"\bbem[- ]vindo\b", r"\bderrotad[oa]\b", r"\bpokebola\b",
    r"\bmensagem\b", r"\bsomente\b", r"\bapenas\b", r"\bnovamente\b", r"\bprimeir[oa]\b",
    r"\bdinheiro\b", r"\bcomprar\b", r"\bvender\b", r"\bfalar\b", r"\bagora\b", r"\baqui\b",
    r"\bsenha\b", r"\bconta\b", r"\bpersonagem\b", r"\bminutos?\b", r"\bsegundos?\b",
    r"\bdias?\b", r"\bsemanas?\b", r"\bhoras?\b", r"\bvolte\b", r"\bvoltar\b", r"\bfechad[oa]\b",
    r"\baberto\b", r"\bporta\b", r"\bchave\b", r"\bcidade\b", r"\bselvagem\b", r"\bcorpo\b",
    r"\bitem necess", r"\bsua\b", r"\bseu\b", r"\bnosso\b", r"\bnossa\b", r"\bdeve\b", r"\bdeseja\b",
    r"\bquer\b", r"\bprecisamos\b", r"\bpossui\b", r"\bexiste\b", r"\bfalta\b", r"\bfaltam\b",
    r"\bganhou\b", r"\bperdeu\b", r"\bvenceu\b", r"\bmorreu\b", r"\bparabéns\b", r"\bparabens\b",
    r"\busado\b", r"\butilize\b", r"\bclique\b", r"\bdireito\b", r"\besquerdo\b", r"\bencima\b",
    r"\bservidor\b", r"\batualização\b", r"\batualizacao\b", r"\bvoltaremos\b",
]
STRONG = re.compile("|".join(STRONG_WORDS), re.IGNORECASE)

# Lines containing only identifiers/paths; skip obvious false positives.
SKIP = re.compile(r"\.(lua|xml|png|ogg|otui|otmod)\b|TM_IDS\.|MOVES\[|POKEMON\[|NPC_|STORAGE|^\s*(local|function|end|return|if|elseif|for|while)\b.*[^\"']$")
COMMENT = re.compile(r"^\s*(--|<!--|//|#)")

EXTS = {".lua", ".xml", ".loc", ".otui", ".otmod", ".txt"}


def decode(data: bytes) -> str:
    try:
        return data.decode("utf-8")
    except UnicodeDecodeError:
        return data.decode("latin-1")


def scan_file(path, include_comments):
    hits = []
    try:
        text = decode(open(path, "rb").read())
    except OSError:
        return hits
    for n, line in enumerate(text.splitlines(), 1):
        if not include_comments and COMMENT.match(line):
            continue
        if SKIP.search(line) and not re.search(r'["\'=]', line):
            continue
        if STRONG.search(line):
            hits.append((n, line.strip()))
    return hits


def main(argv):
    include_comments = "--include-comments" in argv
    summary = "--summary" in argv
    paths = [a for a in argv if not a.startswith("--")] or ["server/data", "server/config.example.lua"]
    total = 0
    per_dir = {}
    for root_path in paths:
        if os.path.isfile(root_path):
            files = [root_path]
        else:
            files = []
            for dp, _, fns in os.walk(root_path):
                for fn in fns:
                    if os.path.splitext(fn)[1].lower() in EXTS:
                        files.append(os.path.join(dp, fn))
        for f in sorted(files):
            if f.endswith("pt_br.loc"):
                continue
            hits = scan_file(f, include_comments)
            if not hits:
                continue
            total += len(hits)
            per_dir[os.path.dirname(f)] = per_dir.get(os.path.dirname(f), 0) + len(hits)
            if not summary:
                for n, line in hits:
                    print(f"{f}:{n}: {line[:200]}")
    if summary:
        for d, c in sorted(per_dir.items(), key=lambda x: -x[1]):
            print(f"{c:5d}  {d}")
    print(f"# {total} suspicious line(s)", file=sys.stderr)


if __name__ == "__main__":
    main(sys.argv[1:])
