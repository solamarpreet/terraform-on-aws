#!/usr/bin/python3

import pathlib

def main():
    folder_name = input("Enter name of folder to restore: ")
    dst = pathlib.Path(".")
    p = dst.joinpath(folder_name)
    if p.exists():
        for _ in p.iterdir():
            _.rename(dst.joinpath(_.name))
    dst.rmdir()

if __name__ == "__main__":
    main()