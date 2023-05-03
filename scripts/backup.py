#!/usr/bin/python3

import pathlib
import sys

def main():
    try:
        folder_name = sys.argv[1]
    except:
        folder_name = input("Enter name of backup folder: ")

    p = pathlib.Path.cwd()
    if p.name == "scripts":
        p = pathlib.Path(p.parent)
        
    dst = p.joinpath(folder_name)
    dst.mkdir(mode=0o770, exist_ok=True)

    for _ in p.glob("*.tf"):
        if not _.stem in ["provider", "backend"]:
            _.rename(dst.joinpath(_.name))

        

if __name__ == "__main__":
    main()