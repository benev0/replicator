import json
import os
import sys
import requests

validArgs = ["-u", "-f"]

if __name__=='__main__':
        args = sys.argv[:]
        print(args)

        uFlag = args.find("-u")
        fFlag = args.find("-f")

        url = ""
        file = ""

        if uFlag < 0 and fFlag < 0:
                print("missing required arguments")
                sys.exit(1)

        if uFlag > 0 and uFlag + 1 >= len(args):
                print("missing url after -u flag")
                sys.exit(1)
        elif uFlag > 0:
                url = args[uFlag + 1]
        else:
                print("missing -u flag")

        if fFlag > 0 and fFlag + 1 >= len(args):
                print("missing file after -u flag")
                sys.exit(1)
        elif fFlag > 0:
                url = args[fFlag + 1]

        if not file:
                # run file gen
                print(f"base file generated at {url}.json")
                sys.exit(0)
        else:
                with open(file, "r") as f:
                        data = f.readlines()
                data = [entry.strip() for entry in data if not entry.startswith("-")]

                ### create server
                # run STDB commands for server
                with open() as f:
                        pass

                ### create client
                # run STDB commands for client
                with open() as f:
                        pass

                print("generated output files at")
