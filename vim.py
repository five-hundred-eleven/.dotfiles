#!/usr/bin/env python

"""
This file will call `ctags` and then `vim` if called without arguments.
It will call `vim` immediately if called with arguments.

Recommend renaming as just `vim` and placing in your path for convenience.

Yes I know it would be very easy to implement this as a bash script, but
this python implementation works too, so whatever.
"""

import os
import subprocess
import sys

TAGS_FILE_PATH = os.path.abspath(os.path.join(".", "tags"))
CTAGS_PATH = "/usr/bin/ctags"
DOT_CTAGS_PATH = "$HOME/.ctags"
VIM_PATH = "/usr/bin/vim"

# call vim directly if we're opening a specific file
if len(sys.argv) >= 2:
    vim_args = [VIM_PATH] + sys.argv[1:]
    os.execv(VIM_PATH, vim_args)

# call ctags
try:
    if os.path.exists(TAGS_FILE_PATH):
        os.rename(TAGS_FILE_PATH, TAGS_FILE_PATH + ".bak")
    ctags_cmd = [CTAGS_PATH]
    proc = subprocess.Popen(
        ctags_cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = proc.communicate()
    if stderr:
        print(stderr, file=sys.stderr)
        sys.exit(1)
except PermissionError:
    pass

# call vim- if we get here `sys.argv[1:]` is an empty list
vim_args = [VIM_PATH] + sys.argv[1:]
os.execv(VIM_PATH, vim_args)
