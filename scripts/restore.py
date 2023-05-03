#!/usr/bin/python3

import pathlib
import sys

def main():
    try:
        folder_name = sys.argv[1]
    except:
        folder_name = input("Enter name of backup folder: ")

    dst = pathlib.Path.cwd()
    if dst.name == "scripts":
        dst = pathlib.Path(dst.parent)
        
    p = dst.joinpath(folder_name)
    if p.exists():
        for _ in p.iterdir():
            _.rename(dst.joinpath(_.name))
    p.rmdir()

if __name__ == "__main__":
    main()