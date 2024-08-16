import errno
import json
import os
import subprocess
import sys
import requests

validArgs = ["-u", "-f"]

def format_dirname(dir: str):
        if dir.startswith('./'):
                return dir[2:]
        return dir[:]

def init_schema(url: str = "", dir: str = "") -> None:
        format_dirname(dir)
        assert dir, "directory name, dir, should not be lambda"
        assert url, "url should not be lambda"

        ### Acquire schema
        r = requests.get(url)
        if r.status_code != 200:
                print(r.status_code, r.reason)
                print("request failed")
                sys.exit(1)

        data = json.loads(r.text)

        ### build file
        try:
                os.makedirs(f"./servers/{dir}")
        except OSError as exc:
                if exc.errno == errno.EEXIST and os.path.isdir(file):
                        print("dir already exists")
                        sys.exit(1)

        with open(f"./servers/{dir}/schema.json", "w+") as f:
                f.writelines(json.dumps(data, indent=8))

        with open(f"./servers/{dir}/schema", "w+") as f:
                f.write(f"--u {url}\n")
                for key in data["entities"].keys():
                        f.write(f"- {key} {data["entities"][key]["type"]} {data["entities"][key]["arity"]}\n")


def build_db(dir: str) -> None:
        subprocess.run(["spacetime", "init", "--lang", "rust", "server"])



def start_client(dir: str) -> None:
        pass


if __name__=='__main__':
        args = sys.argv[1:]
        print(args)

        uFlag = "-u" in args
        fFlag = "-f" in args

        url = ""
        file = ""

        # url and file for schema generation
        # do not use url for copy

        if not uFlag and not fFlag:
                print("missing required arguments")
                sys.exit(1)

        for idx, arg in enumerate(args):
                if not arg in validArgs:
                        continue
                elif arg == "-u" and len(args) > idx + 1 and args[idx + 1] not in validArgs:
                        url = args[idx + 1]
                elif arg == "-f" and len(args) > idx + 1 and args[idx + 1] not in validArgs:
                        file = args[idx + 1]
                else:
                        print(f"missing required arg after {arg}")


        if file and not url:
                # with open(file, "r") as f:
                #         data = f.readlines()
                # data = [entry.strip() for entry in data if not entry.startswith("-")]

                # ### create server
                # # run STDB commands for server
                # with open() as f:
                #         pass

                # ### create client
                # # run STDB commands for client
                # with open() as f:
                #         pass

                print("generated output files at")
        else:
                # run file gen
                init_schema(url, file)
                sys.exit(0)
