#!/usr/bin/env python3
"""Build a minimal uncompressed Arma 3 PBO from an addon directory."""
from pathlib import Path
import struct
import sys


def header(name: str, size: int) -> bytes:
    encoded = name.replace("/", "\\").encode("utf-8") + b"\0"
    return encoded + struct.pack("<5I", 0, 0, 0, 0, size)


def build(source: Path, output: Path, prefix: str) -> None:
    files = sorted(p for p in source.rglob("*") if p.is_file())
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("wb") as stream:
        stream.write(header("prefix", len(prefix.encode("utf-8"))))
        stream.write(prefix.encode("utf-8"))
        for path in files:
            data = path.read_bytes()
            name = path.relative_to(source).as_posix()
            stream.write(header(name, len(data)))
        stream.write(b"\0" * 21)
        for path in files:
            stream.write(path.read_bytes())


if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit("usage: build_pbo.py SOURCE OUTPUT PREFIX")
    build(Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3])
