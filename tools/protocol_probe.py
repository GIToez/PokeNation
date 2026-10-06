#!/usr/bin/env python3
"""Minimal headless client for the PSoul (TFS 0.3.6 / protocol 8.54) server.

Used for Phase 1 verification only: it speaks the real wire protocol (adler32
checksum, RSA with the public OTServ key, XTEA) so the server code paths that a
graphical client would exercise are exercised here too.

Sub-commands:
  status   Query the 0xFF status protocol (disabled in PSoul, see otserv.cpp:877).
  login    Perform a login-protocol (0x01) request and print MOTD + character
           list, including the PSoul OTClient extras.
  enter    Log a character into the game world (0x0A), run a scripted list of
           actions, and log out. Every decrypted server message is parsed
           opcode by opcode (as far as the parser knows the layout) and the
           world state (creatures, containers, inventory, tile items) is tracked
           so later actions can reference things by name.

Actions for `enter` (executed in order):
  --say TEXT               say TEXT in the default channel (talkactions: /cmd, !cmd)
  --walk DIR               north|east|south|west
  --open SLOT              use the item in inventory SLOT (opens containers)
  --move-to-slot SID:SLOT  move the first item with server id SID from an open
                           container into inventory SLOT
  --use-slot SLOT          use the item equipped in SLOT
  --attack NAME            attack the nearest creature whose name starts with NAME
  --stop-attack            cancel attack
  --catch SID              use an item with server id SID (from an open container)
                           on the most recently seen corpse
  --wait-text REGEX:SECS   keep reading until a text message matches REGEX
  --sleep SECS             just read for SECS

Examples:
  tools/protocol_probe.py login --account admin --password admin
  tools/protocol_probe.py enter --account admin --password admin --character "GM Admin" \
      --say "/mypokemon" --open 10 --move-to-slot 12159:8 --use-slot 8 --sleep 2 --use-slot 8
"""
import argparse
import os
import random
import re
import socket
import struct
import sys
import time
import zlib

# Public RSA key of the OTServ community (p*q from otserv.cpp:648-649, e = 65537)
RSA_P = 14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113
RSA_Q = 7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101
RSA_N = RSA_P * RSA_Q
RSA_E = 65537

CLIENTOS_OTCLIENT_WINDOWS = 0x0A
PROTOCOL_VERSION = 312

SPEAK_SAY = 0x01
DIRECTION_OPCODES = {"north": 0x65, "east": 0x66, "south": 0x67, "west": 0x68}

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_OTB = os.path.join(REPO_ROOT, "server", "data", "items", "items.otb")


# ---------------------------------------------------------------------------
# items.otb (needed to know which items carry a count byte and the
# server id <-> client id mapping)
# ---------------------------------------------------------------------------
class ItemTypes:
    FLAG_STACKABLE = 1 << 7
    FLAG_CLIENTCHARGES = 1 << 22
    GROUP_CONTAINER = 2
    GROUP_SPLASH = 11
    GROUP_FLUID = 12

    def __init__(self, path):
        self.by_server = {}
        self.by_client = {}
        if not os.path.exists(path):
            print(f"warning: {path} not found, item parsing disabled", file=sys.stderr)
            return
        data = open(path, "rb").read()
        self._parse(data)

    def _parse(self, data):
        pos = 4  # version dword
        stack = []
        cur = None
        n = len(data)
        while pos < n:
            b = data[pos]
            if b == 0xFE:  # node start
                node = {"type": data[pos + 1], "raw": bytearray()}
                pos += 2
                stack.append(node)
                cur = node
                continue
            if b == 0xFF:  # node end
                node = stack.pop()
                if len(stack) >= 1:
                    self._finish_item(node)
                cur = stack[-1] if stack else None
                pos += 1
                continue
            if b == 0xFD:  # escape
                pos += 1
                b = data[pos]
            if cur is not None:
                cur["raw"].append(b)
            pos += 1

    def _finish_item(self, node):
        raw = bytes(node["raw"])
        if len(raw) < 4:
            return
        flags = struct.unpack_from("<I", raw, 0)[0]
        p = 4
        sid = cid = None
        while p + 3 <= len(raw):
            attr = raw[p]
            ln = struct.unpack_from("<H", raw, p + 1)[0]
            val = raw[p + 3:p + 3 + ln]
            if attr == 0x10 and ln == 2:
                sid = struct.unpack("<H", val)[0]
            elif attr == 0x11 and ln == 2:
                cid = struct.unpack("<H", val)[0]
            p += 3 + ln
        if sid is None:
            return
        group = node["type"]
        has_count = bool(flags & (self.FLAG_STACKABLE | self.FLAG_CLIENTCHARGES)) or group in (self.GROUP_SPLASH, self.GROUP_FLUID)
        info = {"sid": sid, "cid": cid, "count": has_count, "container": group == self.GROUP_CONTAINER}
        self.by_server[sid] = info
        if cid is not None and cid not in self.by_client:
            self.by_client[cid] = info

    def client_id(self, sid):
        return self.by_server[sid]["cid"]

    def server_id(self, cid):
        it = self.by_client.get(cid)
        return it["sid"] if it else None

    def has_count(self, cid):
        it = self.by_client.get(cid)
        return bool(it and it["count"])


# ---------------------------------------------------------------------------
# Byte helpers
# ---------------------------------------------------------------------------
class Writer:
    def __init__(self):
        self.buf = bytearray()

    def u8(self, v):
        self.buf += struct.pack("<B", v)
        return self

    def u16(self, v):
        self.buf += struct.pack("<H", v)
        return self

    def u32(self, v):
        self.buf += struct.pack("<I", v)
        return self

    def string(self, s):
        data = s.encode("latin-1")
        self.u16(len(data))
        self.buf += data
        return self

    def pos(self, p):
        return self.u16(p[0]).u16(p[1]).u8(p[2])

    def raw(self, b):
        self.buf += b
        return self


class Reader:
    def __init__(self, data):
        self.data = data
        self.pos = 0

    def remaining(self):
        return len(self.data) - self.pos

    def u8(self):
        v = self.data[self.pos]
        self.pos += 1
        return v

    def u16(self):
        v = struct.unpack_from("<H", self.data, self.pos)[0]
        self.pos += 2
        return v

    def u32(self):
        v = struct.unpack_from("<I", self.data, self.pos)[0]
        self.pos += 4
        return v

    def string(self):
        n = self.u16()
        s = self.data[self.pos:self.pos + n].decode("latin-1")
        self.pos += n
        return s

    def position(self):
        return (self.u16(), self.u16(), self.u8())

    def skip(self, n):
        self.pos += n


# ---------------------------------------------------------------------------
# Crypto
# ---------------------------------------------------------------------------
def rsa_encrypt_block(block):
    assert len(block) == 128
    m = int.from_bytes(block, "big")
    return pow(m, RSA_E, RSA_N).to_bytes(128, "big")


def xtea_encrypt(data, key):
    data = bytearray(data)
    if len(data) % 8:
        data += bytes(8 - len(data) % 8)
    k = key
    out = bytearray()
    delta = 0x61C88647
    for i in range(0, len(data), 8):
        v0, v1 = struct.unpack_from("<II", data, i)
        s = 0
        for _ in range(32):
            v0 = (v0 + ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (s + k[s & 3]))) & 0xFFFFFFFF
            s = (s - delta) & 0xFFFFFFFF
            v1 = (v1 + ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (s + k[(s >> 11) & 3]))) & 0xFFFFFFFF
        out += struct.pack("<II", v0, v1)
    return bytes(out)


def xtea_decrypt(data, key):
    k = key
    out = bytearray()
    delta = 0x61C88647
    for i in range(0, len(data) - len(data) % 8, 8):
        v0, v1 = struct.unpack_from("<II", data, i)
        s = 0xC6EF3720
        for _ in range(32):
            v1 = (v1 - ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (s + k[(s >> 11) & 3]))) & 0xFFFFFFFF
            s = (s + delta) & 0xFFFFFFFF
            v0 = (v0 - ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (s + k[s & 3]))) & 0xFFFFFFFF
        out += struct.pack("<II", v0, v1)
    return bytes(out)


# ---------------------------------------------------------------------------
# Transport
# ---------------------------------------------------------------------------
class Connection:
    def __init__(self, host, port, timeout=5.0):
        self.sock = socket.create_connection((host, port), timeout=timeout)
        self.key = None

    def send_plain(self, payload):
        """[u16 len][u32 adler32(payload)][payload]"""
        body = struct.pack("<I", zlib.adler32(payload) & 0xFFFFFFFF) + payload
        self.sock.sendall(struct.pack("<H", len(body)) + body)

    def send_encrypted(self, payload):
        inner = struct.pack("<H", len(payload)) + payload
        self.send_plain(xtea_encrypt(inner, self.key))

    def _recv_exact(self, n):
        buf = b""
        while len(buf) < n:
            chunk = self.sock.recv(n - len(buf))
            if not chunk:
                raise ConnectionError("connection closed by server")
            buf += chunk
        return buf

    def recv_message(self):
        """Returns decrypted payload (checksum and XTEA layer removed)."""
        length = struct.unpack("<H", self._recv_exact(2))[0]
        body = self._recv_exact(length)
        checksum = struct.unpack("<I", body[:4])[0]
        payload = body[4:]
        if checksum != (zlib.adler32(payload) & 0xFFFFFFFF):
            raise ValueError("bad adler32 checksum from server")
        if self.key is None:
            inner_len = struct.unpack("<H", payload[:2])[0]
            return payload[2:2 + inner_len]
        dec = xtea_decrypt(payload, self.key)
        inner_len = struct.unpack("<H", dec[:2])[0]
        return dec[2:2 + inner_len]

    def close(self):
        try:
            self.sock.close()
        except OSError:
            pass


def new_xtea_key():
    return [random.getrandbits(32) for _ in range(4)]


def rsa_block(writer_fn):
    w = Writer()
    w.u8(0)
    writer_fn(w)
    block = bytes(w.buf)
    if len(block) > 128:
        raise ValueError("RSA block too long")
    return rsa_encrypt_block(block + bytes(128 - len(block)))


def printable_strings(data, minimum=4):
    return [m.decode("latin-1") for m in re.findall(rb"[\x20-\x7e\xa0-\xff]{%d,}" % minimum, data)]


# ---------------------------------------------------------------------------
# status / login
# ---------------------------------------------------------------------------
def cmd_status(args):
    conn = Connection(args.host, args.status_port)
    conn.send_plain(bytes([0xFF, 0xFF]) + b"info")
    conn.sock.settimeout(5)
    data = b""
    try:
        while True:
            chunk = conn.sock.recv(65536)
            if not chunk:
                break
            data += chunk
    except socket.timeout:
        pass
    conn.close()
    if len(data) >= 2:
        length = struct.unpack("<H", data[:2])[0]
        print(data[2:2 + length].decode("latin-1", "replace"))
        return 0
    print("no status response", file=sys.stderr)
    return 1


def cmd_login(args):
    conn = Connection(args.host, args.login_port)
    key = new_xtea_key()
    w = Writer()
    w.u8(0x01)
    w.u16(CLIENTOS_OTCLIENT_WINDOWS)
    w.u16(PROTOCOL_VERSION)
    w.u8(args.lang)          # language byte, only read for OTClient OS and version >= 293
    w.raw(bytes(12))         # dat/spr/pic signatures (skipped by the server)

    def body(b):
        for k in key:
            b.u32(k)
        b.string(args.account)
        b.string(args.password)

    w.raw(rsa_block(body))
    conn.send_plain(bytes(w.buf))
    conn.key = key

    result = {"motd": None, "characters": [], "premium_days": None, "poll_available": None, "error": None}
    try:
        while True:
            msg = conn.recv_message()
            r = Reader(msg)
            while r.remaining() > 0:
                op = r.u8()
                if op == 0x14:
                    result["motd"] = r.string()
                elif op == 0x0A:
                    result["error"] = r.string()
                elif op == 0x64:
                    for _ in range(r.u8()):
                        c = {"name": r.string(), "world": r.string()}
                        c["ip"] = socket.inet_ntoa(struct.pack("<I", r.u32()))
                        c["port"] = r.u16()
                        # PSoul extras, only sent to OTClient operating systems
                        c["level"] = r.u16()
                        c["vocation"] = r.u8()
                        c["outfit"] = {"looktype": r.u16(), "head": r.u8(), "body": r.u8(),
                                       "legs": r.u8(), "feet": r.u8(), "addons": r.u8()}
                        c["pokemon"] = [(r.u16(), r.string()) for _ in range(r.u8())]
                        result["characters"].append(c)
                    result["premium_days"] = r.u16()
                    if r.remaining() >= 1:
                        result["poll_available"] = bool(r.u8())
                else:
                    print(f"unhandled login opcode 0x{op:02X}", file=sys.stderr)
                    r.pos = len(msg)
    except (ConnectionError, socket.timeout):
        pass
    conn.close()
    if result["error"]:
        print("LOGIN ERROR:", result["error"])
        return 1
    print("MOTD:", repr(result["motd"]))
    print("Premium days:", result["premium_days"], "| poll available:", result["poll_available"])
    for c in result["characters"]:
        print(f"Character: {c['name']!r} world={c['world']!r} {c['ip']}:{c['port']} level={c['level']} "
              f"vocation={c['vocation']} outfit={c['outfit']} pokemon={c['pokemon']}")
    return 0


# ---------------------------------------------------------------------------
# Game protocol parser + world state
# ---------------------------------------------------------------------------
class World:
    def __init__(self, items, verbose=False):
        self.items = items
        self.verbose = verbose
        self.player_id = None
        self.player_pos = None
        self.creatures = {}        # id -> {"name", "pos", "health"}
        self.containers = {}       # cid -> {"name", "items": [(client_id, count)]}
        self.inventory = {}        # slot -> (client_id, count)
        self.tile_items = []       # [(pos, stackpos, client_id)] most recent last
        self.texts = []            # 0xB4 text messages
        self.speech = []           # (name, text)
        self.events = []           # human readable trace
        self.stats = {}
        self.pokeicons = {}        # fastcall number -> (client item id, text)
        self.skills = None         # (icon, [move client ids]) of the Pokémon that is out
        self.statuses = {}         # status icon client id -> cooldown
        self.pokedex_known = None
        self.channels = []

    # -- helpers -----------------------------------------------------------
    def log(self, s):
        self.events.append(s)
        if self.verbose:
            print("   ", s)

    def read_item(self, r):
        cid = r.u16()
        count = r.u8() if self.items.has_count(cid) else 1
        return cid, count

    def read_outfit(self, r):
        looktype = r.u16()
        if looktype:
            r.skip(5)
        else:
            r.u16()

    def read_creature(self, r, pos):
        kind = r.u16()
        if kind == 0x61:
            r.u32()  # remove known id
            cid = r.u32()
            name = r.string()
        elif kind == 0x62:
            cid = r.u32()
            name = self.creatures.get(cid, {}).get("name", "?")
        else:
            raise ValueError("not a creature")
        health = r.u8()
        r.u8()  # direction
        self.read_outfit(r)
        r.skip(2)  # light
        r.u16()    # speed
        r.u8()     # skull
        r.u8()     # party shield
        if kind == 0x61:
            r.u8()  # war emblem
        r.u8()  # creature icon (OTClient only)
        r.u8()  # impassable
        r.u8()  # is my summon (OTClient only)
        r.u8()  # can do combat (OTClient only)
        self.creatures[cid] = {"name": name, "pos": pos, "health": health}
        return cid, name

    def item_name(self, cid):
        sid = self.items.server_id(cid)
        return f"item cid={cid} sid={sid}"

    def peek_u16(self, r):
        return struct.unpack_from("<H", r.data, r.pos)[0]

    def read_tile(self, r, pos):
        """Things on one tile until the 0xFFxx skip marker (marker not consumed)."""
        stackpos = 0
        while r.remaining() >= 2 and stackpos < 256:
            peek = self.peek_u16(r)
            if peek >= 0xFF00:
                return
            if peek in (0x61, 0x62):
                self.read_creature(r, pos)
            else:
                icid, count = self.read_item(r)
                if stackpos > 0:
                    self.tile_items.append((pos, stackpos, icid))
            stackpos += 1

    def read_map(self, r, x, y, z, width, height):
        if z > 7:
            floors = range(z - 2, min(15, z + 2) + 1)
        else:
            floors = range(7, -1, -1)
        skip = 0
        for nz in floors:
            offset = z - nz
            for nx in range(width):
                for ny in range(height):
                    if skip > 0:
                        skip -= 1
                        continue
                    peek = self.peek_u16(r)
                    if peek >= 0xFF00:
                        r.u16()
                        skip = peek & 0xFF
                        continue
                    self.read_tile(r, (x + nx + offset, y + ny + offset, nz))
                    skip = r.u16() & 0xFF

    def parse_psoul(self, r):
        """PSoul custom opcode family 0xFF <sub> (protocolgame.cpp:3050-3370, 4775-4950)."""
        sub = r.u8()
        if sub == 0x01:
            icon = r.u16()
            moves = [r.u16() for _ in range(r.u8())]
            self.skills = (icon, moves)
            self.log(f"[PS] pokemon skills icon={icon} moves={moves}")
        elif sub == 0x02:
            self.log("[PS] skill container close")
        elif sub == 0x03:
            self.log("[PS] skill container open")
        elif sub == 0x04:
            item = r.u16()
            fastcall = r.u16()
            color = r.u8()
            text = r.string()
            self.pokeicons[fastcall] = (item, text)
            self.log(f"[PS] pokemon window add icon item={item} fastcall={fastcall} color={color} text={text!r}")
        elif sub == 0x05:
            fastcall = r.u16()
            self.pokeicons.pop(fastcall, None)
            self.log(f"[PS] pokemon window remove icon fastcall={fastcall}")
        elif sub == 0x06:
            fastcall = r.u16()
            color = r.u8()
            text = r.string()
            if fastcall in self.pokeicons:
                self.pokeicons[fastcall] = (self.pokeicons[fastcall][0], text)
            self.log(f"[PS] pokemon window update icon fastcall={fastcall} color={color} text={text!r}")
        elif sub == 0x07:
            self.log("[PS] pokemon window open")
        elif sub == 0x08:
            self.log("[PS] pokemon window close")
        elif sub == 0x09:
            self.log(f"[PS] skill cooldown item={r.u16()} cooldown={r.u8()}")
        elif sub == 0x0A:
            n = r.u16()
            status = [r.u8() for _ in range(n)]
            self.pokedex_known = sum(1 for s in status if s)
            self.log(f"[PS] pokedex status for {n} pokemon ({self.pokedex_known} known)")
        elif sub == 0x0B:
            self.log("[PS] pokedex open")
        elif sub == 0x0C:
            self.log(f"[PS] pokedex item update number={r.u16()} status={r.u8()}")
        elif sub == 0x11:
            pid = r.u16()
            details = r.string()
            r.string()
            r.string()
            r.string()
            self.log(f"[PS] pokedex info #{pid}: {details[:80]!r}")
        elif sub == 0x0D:
            tm = r.u16()
            moves = [r.u16() for _ in range(r.u8())]
            self.log(f"[PS] TM window move={tm} replaceable={moves}")
        elif sub == 0x0E:
            item, cd = r.u16(), r.u8()
            self.statuses[item] = cd
            self.texts.append(f"[status icon add] item {item} cooldown {cd}")
            self.log(f"[PS] pokemon status add item={item} cooldown={cd}")
        elif sub == 0x0F:
            item = r.u16()
            self.statuses.pop(item, None)
            self.texts.append(f"[status icon remove] item {item}")
            self.log(f"[PS] pokemon status remove item={item}")
        elif sub == 0x10:
            self.statuses.clear()
            self.log("[PS] pokemon status clear")
        elif sub == 0x12:
            self.log(f"[PS] creature jump id={r.u32()}")
        elif sub == 0x13:
            cid = r.u32()
            eff = r.u8()
            self.log(f"[PS] creature effect id={cid} effect={eff} var={r.u32()}")
        elif sub == 0x14:
            n = r.u16()
            r.skip(n)
            self.log(f"[PS] doll case status ({n})")
        elif sub == 0x15:
            self.log(f"[PS] doll case update number={r.u16()} status={r.u8()}")
        elif sub == 0x16:
            self.log(f"[PS] slot machine {r.u8()} {r.u8()} {r.u8()}")
        elif sub == 0x17:
            self.log(f"[PS] tip id={r.u8()}")
        elif sub == 0x18:
            q = r.string()
            text_mode = r.u8()
            opts = [(r.u8(), r.string()) for _ in range(r.u8())]
            self.log(f"[PS] poll {q!r} text_mode={text_mode} options={opts}")
        elif sub == 0x19:
            num = r.u16()
            lvl = r.u8()
            moves = [r.u16() for _ in range(r.u16())]
            self.texts.append(f"[pokemon level up] #{num} -> level {lvl} new moves {moves}")
            self.log(f"[PS] pokemon level up number={num} level={lvl} new_moves={moves}")
        elif sub == 0x1A:
            loot = [(r.u16(), r.u8()) for _ in range(r.u8())]
            self.log(f"[PS] loot list {[(self.items.server_id(c), n) for c, n in loot]}")
        else:
            raise ValueError(f"unknown PSoul sub-opcode 0x{sub:02X}")

    # -- main parser -------------------------------------------------------
    def parse(self, msg):
        """Parse as many opcodes as known. Returns list of opcodes seen."""
        r = Reader(msg)
        seen = []
        try:
            while r.remaining() > 0:
                op = r.u8()
                seen.append(op)
                if op == 0x0A:
                    self.player_id = r.u32()
                    r.u16()  # draw speed
                    r.u8()   # can report bugs
                    hour = r.u16()  # PSoul: real light hour, OTClient only
                    self.log(f"self-login player_id={self.player_id} light_hour={hour}")
                elif op == 0x0B:
                    r.skip(20)  # violation reasons (gamemaster groups)
                elif op == 0x1F:
                    r.skip(5)
                    self.log("challenge")
                elif op == 0x14:
                    self.log("disconnect: " + r.string())
                elif op == 0x16:
                    self.log("waiting list: " + r.string() + f" ({r.u8()}s)")
                elif op == 0x1E:
                    self.log("ping")
                elif op == 0x64:
                    self.player_pos = r.position()
                    x, y, z = self.player_pos
                    self.tile_items = []
                    self.read_map(r, x - 8, y - 6, z, 18, 14)
                    self.log(f"map description at {self.player_pos}: {len(self.creatures)} creatures in view")
                elif op in (0x65, 0x66, 0x67, 0x68):
                    x, y, z = self.player_pos
                    dx, dy = {0x65: (0, -1), 0x66: (1, 0), 0x67: (0, 1), 0x68: (-1, 0)}[op]
                    self.player_pos = (x + dx, y + dy, z)
                    x, y, z = self.player_pos
                    if op == 0x65:
                        self.read_map(r, x - 8, y - 6, z, 18, 1)
                    elif op == 0x66:
                        self.read_map(r, x + 9, y - 6, z, 1, 14)
                    elif op == 0x67:
                        self.read_map(r, x - 8, y + 7, z, 18, 1)
                    else:
                        self.read_map(r, x - 8, y - 6, z, 1, 14)
                    self.log(f"map slice 0x{op:02X} -> player at {self.player_pos}")
                elif op == 0x69:
                    pos = r.position()
                    if self.peek_u16(r) >= 0xFF00:
                        r.u16()
                    else:
                        self.read_tile(r, pos)
                        r.u16()
                    self.log(f"update tile {pos}")
                elif op == 0x6A:
                    pos = r.position()
                    stackpos = r.u8()
                    kind = struct.unpack_from("<H", r.data, r.pos)[0]
                    if kind in (0x61, 0x62):
                        cid, name = self.read_creature(r, pos)
                        self.log(f"add creature {name!r} id={cid} at {pos} stackpos={stackpos}")
                    else:
                        icid, count = self.read_item(r)
                        # things above the insertion point shift up by one
                        self.tile_items = [(p, s + 1 if (p == pos and s >= stackpos) else s, c) for p, s, c in self.tile_items]
                        self.tile_items.append((pos, stackpos, icid))
                        self.log(f"add tile {self.item_name(icid)} x{count} at {pos} stackpos={stackpos}")
                elif op == 0x6B:
                    pos = r.position()
                    stackpos = r.u8()
                    kind = struct.unpack_from("<H", r.data, r.pos)[0]
                    if kind == 0x63:
                        r.u16()
                        cid = r.u32()
                        r.u8()
                        self.log(f"creature {cid} turned")
                    else:
                        icid, count = self.read_item(r)
                        self.tile_items.append((pos, stackpos, icid))
                        self.log(f"transform tile {pos} stackpos={stackpos} -> {self.item_name(icid)}")
                elif op == 0x6C:
                    pos = r.position()
                    stackpos = r.u8()
                    # drop the removed thing; things above it shift down by one
                    self.tile_items = [
                        (p, s - 1 if (p == pos and s > stackpos) else s, c)
                        for p, s, c in self.tile_items
                        if not (p == pos and s == stackpos)
                    ]
                    for c in self.creatures.values():
                        if c["pos"] == pos:
                            c["last_pos"] = pos
                            c["pos"] = None
                    self.log(f"remove thing at {pos} stackpos={stackpos}")
                elif op == 0x6D:
                    old = r.position()
                    r.u8()
                    new = r.position()
                    for c in self.creatures.values():
                        if c["pos"] == old:
                            c["pos"] = new
                    if old == self.player_pos:
                        self.player_pos = new
                    self.log(f"creature moved {old} -> {new}")
                elif op == 0x6E:
                    cid = r.u8()
                    r.u16()  # container client id
                    name = r.string()
                    r.u8()   # capacity
                    r.u8()   # has parent
                    n = r.u8()
                    items = [self.read_item(r) for _ in range(n)]
                    self.containers[cid] = {"name": name, "items": items}
                    self.log(f"open container {cid} {name!r}: " + ", ".join(f"{self.item_name(i)} x{c}" for i, c in items))
                elif op == 0x6F:
                    cid = r.u8()
                    self.containers.pop(cid, None)
                    self.log(f"close container {cid}")
                elif op == 0x70:
                    cid = r.u8()
                    it = self.read_item(r)
                    self.containers.setdefault(cid, {"name": "?", "items": []})["items"].insert(0, it)
                    self.log(f"container {cid} add {self.item_name(it[0])} x{it[1]}")
                elif op == 0x71:
                    cid = r.u8()
                    slot = r.u8()
                    it = self.read_item(r)
                    c = self.containers.setdefault(cid, {"name": "?", "items": []})
                    if slot < len(c["items"]):
                        c["items"][slot] = it
                    self.log(f"container {cid} slot {slot} -> {self.item_name(it[0])} x{it[1]}")
                elif op == 0x72:
                    cid = r.u8()
                    slot = r.u8()
                    c = self.containers.get(cid)
                    if c and slot < len(c["items"]):
                        c["items"].pop(slot)
                    self.log(f"container {cid} remove slot {slot}")
                elif op == 0x78:
                    slot = r.u8()
                    it = self.read_item(r)
                    self.inventory[slot] = it
                    self.log(f"inventory slot {slot} = {self.item_name(it[0])} x{it[1]}")
                elif op == 0x79:
                    slot = r.u8()
                    self.inventory.pop(slot, None)
                    self.log(f"inventory slot {slot} empty")
                elif op == 0x82:
                    r.skip(2)  # world light
                elif op == 0x83:
                    pos = r.position()
                    eff = r.u16()  # PSoul: u16 effect id (stock 8.54 is u8)
                    self.log(f"magic effect {eff} at {pos}")
                elif op == 0x84:
                    pos = r.position()
                    color = r.u8()
                    self.log(f"animated text {r.string()!r} color={color} at {pos}")
                elif op == 0x85:
                    a = r.position()
                    b = r.position()
                    self.log(f"distance shoot {r.u8()} {a}->{b}")
                elif op == 0x86:
                    self.log(f"creature square id={r.u32()} color={r.u8()}")
                elif op == 0x8C:
                    cid = r.u32()
                    hp = r.u8()
                    if cid in self.creatures:
                        self.creatures[cid]["health"] = hp
                    self.log(f"creature {cid} ({self.creatures.get(cid, {}).get('name')}) health {hp}%")
                elif op == 0x8D:
                    r.u32()
                    r.skip(2)
                elif op == 0x8E:
                    cid = r.u32()
                    self.read_outfit(r)
                    self.log(f"creature {cid} outfit changed")
                elif op == 0x8F:
                    cid = r.u32()
                    self.log(f"creature {cid} speed {r.u16()}")
                elif op == 0x90:
                    r.u32()
                    r.u8()
                elif op == 0x91:
                    r.u32()
                    r.u8()
                elif op == 0xA0:
                    hp = r.u16()
                    hpmax = r.u16()
                    r.u32()
                    exp = r.u32()
                    lvl = r.u16()
                    r.u8()
                    mana = r.u16()
                    manamax = r.u16()
                    r.u8()
                    r.u8()
                    soul = r.u8()
                    r.u16()
                    self.stats = {"hp": hp, "hpmax": hpmax, "exp": exp, "level": lvl,
                                  "energy": mana, "energymax": manamax, "respect": soul}
                    self.log(f"player stats hp={hp}/{hpmax} exp={exp} level={lvl} energy={mana}/{manamax} respect={soul}")
                elif op == 0xA1:
                    r.skip(14)
                elif op == 0xA2:
                    r.u16()
                elif op == 0xA3:
                    self.log("cancel target")
                elif op == 0xAA:
                    r.u32()
                    name = r.string()
                    level = r.u16()
                    typ = r.u8()
                    if typ in (0x01, 0x02, 0x03, 0x04, 0x13, 0x14, 0x05):  # say/whisper/yell/monster/private np
                        pos = r.position()
                    elif typ in (0x07, 0x0C, 0x0D, 0x0E, 0x0F):  # channel types
                        r.u16()
                    text = r.string()
                    self.speech.append((name, text))
                    self.log(f"{name!r} (lvl {level}) says type=0x{typ:02X}: {text!r}")
                elif op == 0xAB:
                    # PSoul: U16 channel count (stock 8.54 uses U8) - see docs/SOURCE_AUDIT.md
                    n = r.u16()
                    chans = [(r.u16(), r.string()) for _ in range(n)]
                    self.channels = chans
                    self.texts.append(f"[channel list] {chans}")
                    self.log(f"channel list ({n}): {chans}")
                elif op == 0xAC:
                    cid_, name = r.u16(), r.string()
                    self.texts.append(f"[channel open] {cid_} {name!r}")
                    self.log(f"open channel {cid_} {name!r}")
                elif op == 0xB2:
                    self.log(f"private channel created {r.u16()} {r.string()!r}")
                elif op == 0xB3:
                    self.log(f"channel closed {r.u16()}")
                elif op == 0xB4:
                    cls = r.u8()
                    text = r.string()
                    self.texts.append(text)
                    self.log(f"text 0x{cls:02X}: {text!r}")
                elif op == 0xB5:
                    r.u8()
                    self.log("cancel walk")
                elif op == 0xBE or op == 0xBF:
                    self.log(f"floor change 0x{op:02X} (not parsed)")
                    break
                elif op == 0x32:
                    ext = r.u8()
                    self.log(f"extended opcode {ext}: {r.string()[:100]!r}")
                elif op == 0xFF:
                    self.parse_psoul(r)
                else:
                    self.log(f"unknown opcode 0x{op:02X}, {r.remaining()} bytes left unparsed")
                    break
        except (IndexError, struct.error, ValueError) as e:
            self.log(f"parse error after opcodes {[hex(o) for o in seen]}: {e}")
        return seen


def inv_pos(slot):
    return (0xFFFF, slot, 0)


def container_pos(cid, index):
    return (0xFFFF, 0x40 | cid, index)


def cmd_enter(args):
    items = ItemTypes(args.items_otb)
    world = World(items, verbose=args.verbose)
    conn = Connection(args.host, args.game_port)
    # The game server greets every connection with an unencrypted 0x1F
    # challenge (protocolgame.cpp:438 onConnect) before the client logs in.
    challenge = conn.recv_message()
    if not challenge or challenge[0] != 0x1F:
        print(f"!! unexpected greeting {challenge.hex()}")
        return 1
    key = new_xtea_key()
    w = Writer()
    w.u8(0x0A)
    w.u16(CLIENTOS_OTCLIENT_WINDOWS)
    w.u16(PROTOCOL_VERSION)

    def body(b):
        for k in key:
            b.u32(k)
        b.u8(0)  # gamemaster client flag
        b.string(args.account)
        b.string(args.character)
        b.string(args.password)
        b.raw(bytes(6))  # bytes skipped by the server after the strings

    w.raw(rsa_block(body))
    conn.send_plain(bytes(w.buf))
    conn.key = key

    def pump(seconds, until=None):
        deadline = time.time() + seconds
        conn.sock.settimeout(0.3)
        while time.time() < deadline:
            try:
                msg = conn.recv_message()
            except socket.timeout:
                continue
            except ConnectionError as e:
                print("<< connection closed:", e)
                return False
            before = len(world.texts)
            ops = world.parse(msg)
            if 0x1E in ops:
                conn.send_encrypted(bytes([0x1E]))
            if until and any(until.search(t) for t in world.texts[before:]):
                return True
        return True

    def find_in_containers(sid):
        want = items.client_id(sid)
        for cid, c in world.containers.items():
            for idx, (icid, cnt) in enumerate(c["items"]):
                if icid == want:
                    return cid, idx, icid, cnt
        return None

    def nearest_creature(prefix):
        best = None
        for cid, c in world.creatures.items():
            if cid == world.player_id or not c["pos"] or not c["name"].lower().startswith(prefix.lower()):
                continue
            d = 0
            if world.player_pos:
                d = abs(c["pos"][0] - world.player_pos[0]) + abs(c["pos"][1] - world.player_pos[1])
            if best is None or d < best[0]:
                best = (d, cid, c)
        return best

    def walk_to(tx, ty):
        # greedy walk towards x,y on the current floor (open terrain only); alternates axis when blocked
        print(f">> walk to ({tx}, {ty}) from {world.player_pos}")
        stuck = 0
        while world.player_pos and (world.player_pos[0], world.player_pos[1]) != (tx, ty) and stuck < 6:
            x, y, _ = world.player_pos
            before = world.player_pos
            steps = []
            if tx != x:
                steps.append("east" if tx > x else "west")
            if ty != y:
                steps.append("south" if ty > y else "north")
            step = steps[stuck % len(steps)]
            conn.send_encrypted(bytes([DIRECTION_OPCODES[step]]))
            pump(0.8)
            if world.player_pos == before:
                stuck += 1
                pump(0.7)
            else:
                stuck = 0
        print(f"   now at {world.player_pos}" + ("" if stuck < 6 else " (gave up: blocked)"))
        return stuck < 6

    print(f">> entering world as {args.character!r}")
    if not pump(args.settle):
        return 1
    if world.player_id is None:
        print("!! did not receive self-login packet (0x0A)")
        return 1
    print(f"<< in game: player_id={world.player_id} pos={world.player_pos} stats={world.stats}")
    print(f"<< inventory: { {s: items.server_id(c) for s, (c, _) in sorted(world.inventory.items())} }")

    ok = True
    for action in args.actions:
        kind, _, value = action.partition(":")
        if kind == "say":
            print(f">> say {value!r}")
            conn.send_encrypted(bytes(Writer().u8(0x96).u8(SPEAK_SAY).string(value).buf))
            pump(args.wait)
        elif kind == "npc":
            # talk through the NPC channel (SPEAK_PRIVATE_PN), as the client's NPC window does;
            # focused NPCs ignore plain 'say' (npc/lib/npcsystem/npchandler.lua:433)
            print(f">> npc-say {value!r}")
            conn.send_encrypted(bytes(Writer().u8(0x96).u8(0x04).string(value).buf))
            pump(args.wait)
        elif kind == "walk":
            print(f">> walk {value}")
            conn.send_encrypted(bytes([DIRECTION_OPCODES[value]]))
            pump(args.wait)
        elif kind == "face":
            # turn towards the nearest creature with that name (must be orthogonally adjacent)
            best = nearest_creature(value)
            if not best or not world.player_pos:
                print(f"!! no creature named {value!r} in view")
                ok = False
                continue
            dx = best[2]["pos"][0] - world.player_pos[0]
            dy = best[2]["pos"][1] - world.player_pos[1]
            turn = {(0, -1): 0x6F, (1, 0): 0x70, (0, 1): 0x71, (-1, 0): 0x72}.get((dx, dy))
            if turn is None:
                print(f"!! {best[2]['name']!r} is not adjacent (dx={dx}, dy={dy})")
                ok = False
                continue
            print(f">> face {best[2]['name']!r}")
            conn.send_encrypted(bytes([turn]))
            pump(args.wait)
        elif kind == "walkto":
            tx, ty = (int(v) for v in value.split(","))
            ok = walk_to(tx, ty) and ok
        elif kind == "approach":
            # walk next to the nearest creature with that name and turn towards it
            best = nearest_creature(value)
            if not best or not world.player_pos:
                print(f"!! no creature named {value!r} in view")
                ok = False
                continue
            cx, cy, _ = best[2]["pos"]
            px, py, _ = world.player_pos
            adj = min([(cx, cy + 1), (cx, cy - 1), (cx + 1, cy), (cx - 1, cy)],
                      key=lambda t: abs(t[0] - px) + abs(t[1] - py))
            if walk_to(*adj):
                c = world.creatures[best[1]]
                dx, dy = c["pos"][0] - world.player_pos[0], c["pos"][1] - world.player_pos[1]
                turn = {(0, -1): 0x6F, (1, 0): 0x70, (0, 1): 0x71, (-1, 0): 0x72}.get((dx, dy))
                if turn is not None:
                    conn.send_encrypted(bytes([turn]))
                    pump(args.wait)
                else:
                    print(f"!! {c['name']!r} moved away (dx={dx}, dy={dy})")
                    ok = False
            else:
                ok = False
        elif kind == "waitpos":
            # wait until the player is at x,y (e.g. after a GM /send) - value "x,y:seconds"
            coords, _, secs = value.rpartition(":")
            tx, ty = (int(v) for v in coords.split(","))
            deadline = time.time() + float(secs)
            print(f">> wait up to {secs}s to be at ({tx}, {ty})")
            while time.time() < deadline and (world.player_pos[0], world.player_pos[1]) != (tx, ty):
                pump(0.5)
            print(f"   {'arrived' if (world.player_pos[0], world.player_pos[1]) == (tx, ty) else 'TIMEOUT'} at {world.player_pos}")
        elif kind == "open":
            slot = int(value)
            it = world.inventory.get(slot)
            if not it:
                print(f"!! nothing in slot {slot}")
                ok = False
                continue
            print(f">> use inventory slot {slot} ({items.server_id(it[0])})")
            conn.send_encrypted(bytes(Writer().u8(0x82).pos(inv_pos(slot)).u16(it[0]).u8(0).u8(0).buf))
            pump(args.wait)
        elif kind == "useslot":
            slot = int(value)
            it = world.inventory.get(slot)
            if not it:
                print(f"!! nothing in slot {slot}")
                ok = False
                continue
            print(f">> use inventory slot {slot} (server id {items.server_id(it[0])})")
            conn.send_encrypted(bytes(Writer().u8(0x82).pos(inv_pos(slot)).u16(it[0]).u8(0).u8(0).buf))
            pump(args.wait)
        elif kind == "raw":
            data = bytes.fromhex(value)
            print(f">> send raw packet {data.hex()}")
            conn.send_encrypted(data)
            pump(args.wait)
        elif kind == "callpoke":
            # emulate clicking a Pokémon bar icon: the client says "/cp <fastcall>"
            want = int(value)
            fc = next((f for f, (item, _) in sorted(world.pokeicons.items()) if item == want), None)
            if fc is None:
                print(f"!! no Pokémon bar icon with client item {want}; icons={world.pokeicons}")
                ok = False
                continue
            print(f">> call Pokémon icon item={want} fastcall={fc} ('/cp {fc}')")
            conn.send_encrypted(bytes(Writer().u8(0x96).u8(SPEAK_SAY).string(f"/cp {fc}").buf))
            pump(args.wait)
        elif kind == "useitem":
            sid = int(value)
            found = find_in_containers(sid)
            if not found:
                print(f"!! item {sid} not found in open containers {list(world.containers)}")
                ok = False
                continue
            cid, idx, icid, cnt = found
            print(f">> use item {sid} from container {cid}[{idx}]")
            conn.send_encrypted(bytes(Writer().u8(0x82).pos(container_pos(cid, idx)).u16(icid).u8(idx).u8(0).buf))
            pump(args.wait)
        elif kind == "useon":
            # use item <sid> (from an open container or inventory slot) on the nearest creature <name>
            sid, _, target = value.partition(":")
            sid = int(sid)
            found = find_in_containers(sid)
            if found:
                cid, idx, icid, cnt = found
                from_pos, from_stack = container_pos(cid, idx), idx
            else:
                slot = next((s for s, (c, _) in world.inventory.items() if items.server_id(c) == sid), None)
                if slot is None:
                    print(f"!! item {sid} not found in containers or inventory")
                    ok = False
                    continue
                icid = world.inventory[slot][0]
                from_pos, from_stack = inv_pos(slot), 0
            best = nearest_creature(target)
            if not best:
                print(f"!! no creature named {target!r} in view")
                ok = False
                continue
            print(f">> use item {sid} on creature {best[2]['name']!r} id={best[1]}")
            conn.send_encrypted(bytes(Writer().u8(0x84).pos(from_pos).u16(icid).u8(from_stack).u32(best[1]).buf))
            pump(args.wait)
        elif kind == "useontile":
            # use item <sid> (container or inventory slot) on a map tile: "SID:self" = the player's own
            # tile (order icon -> Ride/Fly/Surf...), "SID:X,Y" = another tile on the current floor.
            # Without a stackpos the server resolves the *source* with STACKPOS_USEITEM but the
            # *target* with the exact stackpos (Actions::executeUse -> internalGetThing), i.e. 0 =
            # ground.  Append ":STACK" (e.g. "14048:self:3") to aim at an item lying on the tile;
            # --drop prints the stackpos the dropped item got.
            sid, _, target = value.partition(":")
            sid = int(sid)
            target, _, to_stack = target.partition(":")
            to_stack = int(to_stack) if to_stack else 0
            found = find_in_containers(sid)
            if found:
                cid, idx, icid, cnt = found
                from_pos, from_stack = container_pos(cid, idx), idx
            else:
                slot = next((s for s, (c, _) in world.inventory.items() if items.server_id(c) == sid), None)
                if slot is None:
                    print(f"!! item {sid} not found in containers or inventory")
                    ok = False
                    continue
                icid = world.inventory[slot][0]
                from_pos, from_stack = inv_pos(slot), 0
            me = world.creatures[world.player_id]["pos"] or world.creatures[world.player_id].get("last_pos")
            if not me:
                print("!! player position unknown")
                ok = False
                continue
            if target == "self":
                to_pos = me
            else:
                x, y = (int(v) for v in target.split(","))
                to_pos = (x, y, me[2])
            print(f">> use item {sid} on tile {to_pos} stackpos {to_stack}")
            conn.send_encrypted(bytes(Writer().u8(0x83).pos(from_pos).u16(icid).u8(from_stack)
                                      .pos(to_pos).u16(0).u8(to_stack).buf))
            pump(args.wait)
        elif kind == "useonslot":
            # use item <sid> from an open container on the item equipped in inventory <slot>
            # (e.g. a TM / vitamin / held item on the ball in slot 8)
            sid, slot = (int(x) for x in value.split(":"))
            found = find_in_containers(sid)
            if not found:
                print(f"!! item {sid} not found in open containers {list(world.containers)}")
                ok = False
                continue
            if slot not in world.inventory:
                print(f"!! inventory slot {slot} is empty")
                ok = False
                continue
            cid, idx, icid, cnt = found
            to_cid = world.inventory[slot][0]
            print(f">> use item {sid} on inventory slot {slot} ({items.server_id(to_cid)})")
            conn.send_encrypted(bytes(Writer().u8(0x83).pos(container_pos(cid, idx)).u16(icid).u8(idx)
                                      .pos(inv_pos(slot)).u16(to_cid).u8(0).buf))
            pump(args.wait)
        elif kind == "movetoslot":
            sid, slot = (int(x) for x in value.split(":"))
            found = find_in_containers(sid)
            if not found:
                print(f"!! item {sid} not found in open containers {list(world.containers)}")
                ok = False
                continue
            cid, idx, icid, cnt = found
            print(f">> move item {sid} from container {cid}[{idx}] to slot {slot}")
            p = Writer().u8(0x78).pos(container_pos(cid, idx)).u16(icid).u8(idx).pos(inv_pos(slot)).u8(cnt)
            conn.send_encrypted(bytes(p.buf))
            pump(args.wait)
        elif kind == "drop":
            # move item <sid> from an open container onto the player's own tile
            sid = int(value)
            found = find_in_containers(sid)
            if not found:
                print(f"!! item {sid} not found in open containers {list(world.containers)}")
                ok = False
                continue
            cid, idx, icid, cnt = found
            pos = world.creatures[world.player_id]["pos"]
            print(f">> drop item {sid} from container {cid}[{idx}] onto {pos}")
            p = Writer().u8(0x78).pos(container_pos(cid, idx)).u16(icid).u8(idx).pos(pos).u8(max(cnt, 1))
            conn.send_encrypted(bytes(p.buf))
            pump(args.wait)
        elif kind == "movetobag":
            slot = int(value)
            it = world.inventory.get(slot)
            if not it or not world.containers:
                print(f"!! nothing in slot {slot} or no open container")
                ok = False
                continue
            cid = sorted(world.containers)[0]
            print(f">> move slot {slot} item ({items.server_id(it[0])}) into container {cid}")
            p = Writer().u8(0x78).pos(inv_pos(slot)).u16(it[0]).u8(0).pos(container_pos(cid, 0)).u8(it[1])
            conn.send_encrypted(bytes(p.buf))
            pump(args.wait)
        elif kind == "waitdead":
            prefix, _, secs = value.rpartition(":")
            deadline = time.time() + float(secs)
            target = nearest_creature(prefix)
            if not target:
                # already gone from view (killed before this action started)? use the last known creature
                gone = [(cid_, c) for cid_, c in world.creatures.items()
                        if c["name"].lower().startswith(prefix.lower()) and c["pos"] is None and c.get("last_pos")]
                if not gone:
                    print(f"!! no creature {prefix!r} to wait for")
                    ok = False
                    continue
                target = (0, gone[-1][0], gone[-1][1])
            tid = target[1]
            print(f">> wait up to {secs}s for {target[2]['name']!r} id={tid} to die")
            while time.time() < deadline:
                pump(1.0)
                c = world.creatures.get(tid)
                if c["pos"] is None or c["health"] == 0:
                    break
            c = world.creatures.get(tid)
            dead = c["pos"] is None or c["health"] == 0
            corpse_pos = c["pos"] or c.get("last_pos")
            world.corpse_pos = corpse_pos
            on_tile = [(items.server_id(t[2]), t[1]) for t in world.tile_items if t[0] == corpse_pos]
            print(f"   {'dead' if dead else 'STILL ALIVE'}: health={c['health']}% died at {corpse_pos}; "
                  f"items on that tile (sid, stackpos): {on_tile}")
            ok = ok and dead
        elif kind == "attack":
            best = nearest_creature(value)
            if not best:
                print(f"!! no creature named {value!r} in view: {[c['name'] for c in world.creatures.values()]}")
                ok = False
                continue
            print(f">> attack {best[2]['name']!r} id={best[1]} at {best[2]['pos']}")
            conn.send_encrypted(bytes(Writer().u8(0xA1).u32(best[1]).buf))
            pump(args.wait)
        elif kind == "stopattack":
            conn.send_encrypted(bytes(Writer().u8(0xA1).u32(0).buf))
            pump(args.wait)
        elif kind == "catch":
            sid = int(value)
            found = find_in_containers(sid)
            if not found or not world.tile_items:
                print(f"!! need an open container with item {sid} and a visible corpse")
                ok = False
                continue
            cid, idx, icid, cnt = found
            corpse_pos = getattr(world, "corpse_pos", None)
            candidates = [t for t in world.tile_items if corpse_pos is None or t[0] == corpse_pos]
            if not candidates:
                print(f"!! no item seen on the tile where the creature died ({corpse_pos})")
                ok = False
                continue
            # the corpse is the topmost (last added) item on the death tile
            pos, stackpos, corpse_cid = max(candidates, key=lambda t: t[1])
            print(f">> use {sid} on corpse {items.server_id(corpse_cid)} at {pos} stackpos={stackpos}")
            p = Writer().u8(0x83).pos(container_pos(cid, idx)).u16(icid).u8(idx).pos(pos).u16(corpse_cid).u8(stackpos)
            conn.send_encrypted(bytes(p.buf))
            pump(args.wait)
        elif kind == "usecorpse":
            # use (open) the corpse left by the last --wait-dead target; with /autoloot on this is
            # the loot-collection path (actions.cpp, "Loot collected.")
            corpse_pos = getattr(world, "corpse_pos", None)
            candidates = [t for t in world.tile_items if corpse_pos is None or t[0] == corpse_pos]
            if not candidates:
                print(f"!! no item seen on the tile where the creature died ({corpse_pos})")
                ok = False
                continue
            pos, stackpos, corpse_cid = max(candidates, key=lambda t: t[1])
            print(f">> use corpse {items.server_id(corpse_cid)} at {pos} stackpos={stackpos}")
            conn.send_encrypted(bytes(Writer().u8(0x82).pos(pos).u16(corpse_cid).u8(stackpos).u8(0).buf))
            pump(args.wait)
        elif kind == "waittext":
            pattern, _, secs = value.rpartition(":")
            rx = re.compile(pattern, re.I)
            print(f">> wait up to {secs}s for text /{pattern}/")
            if any(rx.search(t) for t in world.texts):
                print("   (already received)")
                continue
            t0 = time.time()
            pump(float(secs), until=rx)
            hit = [t for t in world.texts if rx.search(t)]
            print(f"   {'matched' if hit else 'TIMEOUT'} after {time.time() - t0:.1f}s: {hit[-1:]}")
            ok = ok and bool(hit)
        elif kind == "sleep":
            pump(float(value))
        else:
            print("unknown action", action, file=sys.stderr)

    if not args.stay:
        print(">> logout")
        conn.send_encrypted(bytes([0x14]))
        pump(1.0)
    conn.close()

    print("\n=== creatures seen ===")
    for cid, c in world.creatures.items():
        print(f" - {c['name']!r} id={cid} pos={c['pos']} health={c['health']}%")
    print("=== speech ===")
    for name, text in world.speech:
        print(f" - {name}: {text}")
    print(f"=== Pokémon bar icons === {world.pokeicons}")
    print(f"=== active Pokémon skills === {world.skills}  statuses={world.statuses}")
    print("=== text messages (0xB4) ===")
    for t in world.texts:
        print(" -", t)
    if args.trace:
        print("=== event trace ===")
        for e in world.events:
            print(" ", e)
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--login-port", type=int, default=7564)
    ap.add_argument("--game-port", type=int, default=8548)
    ap.add_argument("--status-port", type=int, default=7190)
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("status")

    pl = sub.add_parser("login")
    pl.add_argument("--account", required=True)
    pl.add_argument("--password", required=True)
    pl.add_argument("--lang", type=int, default=0, help="language id sent by OTClient (0 = English)")

    pe = sub.add_parser("enter")
    pe.add_argument("--account", required=True)
    pe.add_argument("--password", required=True)
    pe.add_argument("--character", required=True)
    pe.add_argument("--items-otb", default=DEFAULT_OTB)
    pe.add_argument("--say", dest="actions", action="append", default=[], type=lambda s: "say:" + s)
    pe.add_argument("--npc", dest="actions", action="append", type=lambda s: "npc:" + s,
                    help="say something in the NPC channel (needed once an NPC is focused)")
    pe.add_argument("--walk", dest="actions", action="append", type=lambda s: "walk:" + s)
    pe.add_argument("--face", dest="actions", action="append", type=lambda s: "face:" + s,
                    help="turn towards the adjacent creature whose name starts with NAME")
    pe.add_argument("--approach", dest="actions", action="append", type=lambda s: "approach:" + s,
                    help="walk next to the creature whose name starts with NAME and face it")
    pe.add_argument("--walk-to", dest="actions", action="append", type=lambda s: "walkto:" + s,
                    help="X,Y - greedy walk to that tile on the current floor")
    pe.add_argument("--wait-pos", dest="actions", action="append", type=lambda s: "waitpos:" + s,
                    help="X,Y:SECONDS - wait until the player stands on that tile")
    pe.add_argument("--open", dest="actions", action="append", type=lambda s: "open:" + s)
    pe.add_argument("--use-slot", dest="actions", action="append", type=lambda s: "useslot:" + s)
    pe.add_argument("--raw", dest="actions", action="append", type=lambda s: "raw:" + s,
                    help="send a raw client packet given as hex (e.g. 97 = request channel list)")
    pe.add_argument("--call-poke", dest="actions", action="append", type=lambda s: "callpoke:" + s,
                    help="click the Pokémon bar icon whose client item id is given (sends '/cp N')")
    pe.add_argument("--use-item", dest="actions", action="append", type=lambda s: "useitem:" + s,
                    help="use an item (server id) found in an open container")
    pe.add_argument("--use-on", dest="actions", action="append", type=lambda s: "useon:" + s,
                    help="SID:NAME - use item SID on the nearest creature whose name starts with NAME")
    pe.add_argument("--use-on-slot", dest="actions", action="append", type=lambda s: "useonslot:" + s,
                    help="SID:SLOT - use item SID (from an open container) on the item in inventory SLOT")
    pe.add_argument("--use-corpse", dest="actions", action="append_const", const="usecorpse:",
                    help="open the corpse of the last --wait-dead target (autoloot path)")
    pe.add_argument("--use-on-tile", dest="actions", action="append", type=lambda s: "useontile:" + s,
                    help="SID:self[:STACK] or SID:X,Y[:STACK] - use item SID on the player's own tile or on "
                         "another tile (order icon 7730 on your own tile = Ride/Fly/Dive); STACK targets "
                         "the item at that stackpos instead of the ground (e.g. incubator on a dropped egg)")
    pe.add_argument("--drop", dest="actions", action="append", type=lambda s: "drop:" + s,
                    help="SID - move item SID from an open container onto the player's own tile")
    pe.add_argument("--move-to-slot", dest="actions", action="append", type=lambda s: "movetoslot:" + s)
    pe.add_argument("--move-to-bag", dest="actions", action="append", type=lambda s: "movetobag:" + s)
    pe.add_argument("--wait-dead", dest="actions", action="append", type=lambda s: "waitdead:" + s)
    pe.add_argument("--attack", dest="actions", action="append", type=lambda s: "attack:" + s)
    pe.add_argument("--stop-attack", dest="actions", action="append_const", const="stopattack:")
    pe.add_argument("--catch", dest="actions", action="append", type=lambda s: "catch:" + s)
    pe.add_argument("--wait-text", dest="actions", action="append", type=lambda s: "waittext:" + s)
    pe.add_argument("--sleep", dest="actions", action="append", type=lambda s: "sleep:" + s)
    pe.add_argument("--settle", type=float, default=3.0, help="seconds to read after login")
    pe.add_argument("--wait", type=float, default=1.5, help="seconds to read after each action")
    pe.add_argument("--stay", action="store_true", help="do not send logout at the end")
    pe.add_argument("--trace", action="store_true", help="print the full event trace at the end")
    pe.add_argument("-v", "--verbose", action="store_true", help="print events as they happen")

    args = ap.parse_args()
    if args.cmd == "status":
        return cmd_status(args)
    if args.cmd == "login":
        return cmd_login(args)
    return cmd_enter(args)


if __name__ == "__main__":
    sys.exit(main())
