#!/usr/bin/env python3
# 3.7 required for https://pypi.org/project/shell-scripting
from sys import argv, exit, path
from importlib import import_module
from shell_scripting import run
from yaml import load

# get XDG_CONFIG_HOME
try:
    # pip3 install pyxdg
    from xdg.BaseDirectory import xdg_config_home as XDG_CONFIG_HOME
except ImportError:
    try:
        # pip3 install xdg
        from xdg import XDG_CONFIG_HOME
    except ImportError:
        from os.path import expanduser

        XDG_CONFIG_HOME = expanduser("~") + "/.config"


def run_print_str(s):
    try:
        if config["show_command"]:
            print(s)
            run(s)
            print(s)
        else:
            run(s)
    except KeyboardInterrupt:
        print()


def load_from_dir(dirs, f):
    for x in dirs:
        try:
            yml_file_path = "{}/{}".format(x, f)
            with open(yml_file_path, "r") as y:
                return yml_file_path, load(y)
        except FileNotFoundError:
            continue
        else:
            break


dir_list = [XDG_CONFIG_HOME + "/x", "/etc/x", path[0]]

config_path, config = load_from_dir(dir_list, "config.yml")
pm_path, pm = load_from_dir(dir_list, "pm/" + config["package_manager"] + ".yml")

argv_len = len(argv) - 1
if argv_len == 0:
    run_print_str(pm["u"]["command"])

if argv_len == 1:
    if argv[1] in ["-h", "--help", "help"]:
        tab_size = len(max([x["help"] for x in pm.values()], key=len)) + 1

        for x in pm:
            print(
                "{:<5}{:<{tab_size}}{}".format(
                    x, pm[x]["help"], pm[x]["command"], tab_size=tab_size
                )
            )
        exit()

    if argv[1][0] == ":":
        try:
            run_print_str(pm[argv[1][1:]]["command"])
        except KeyError as e:
            print("command", e, "not found in", pm_path)

        exit()

    run_print_str("{} {}".format(pm[config["default_command"]]["command"], argv[1]))

if argv_len >= 2:
    try:
        command = pm[argv[1]]["command"]
    except KeyError:
        exit("syntax with ':' available only for command without parameters")

    if command.count("{}") > 0:
        try:
            command_str = command.format(*argv[2:])
        except IndexError:
            exit(
                '{} "{}"'.format(
                    "number of arguments does not match the command", command
                )
            )
    else:
        command_str = "{} {}".format(command, " ".join(argv[2:]))

    run_print_str(command_str)
