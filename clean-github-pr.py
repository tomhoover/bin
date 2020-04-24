#!/usr/bin/env python3

# clean-github-pr --- Create tidy repositories for pull requests
#
# Copyright (C) 2016  Sean Whitton
#
# clean-github-pr is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# clean-github-pr is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with clean-github-pr.  If not, see <http://www.gnu.org/licenses/>.
#
# 200423: converted to python3 by Tom Hoover

import github

import sys
import time
import tempfile
import shutil
import subprocess
import os

CREDS_FILE = os.getenv("HOME") + "/.cache/clean-github-pr-creds"

def main():
    # check arguments
    if len(sys.argv) != 2:
        print(sys.argv[0] + ": usage: " + sys.argv[0] + " USER/REPO")
        sys.exit(1)

    # check creds file
    try:
        f = open(CREDS_FILE, 'r')
    except IOError:
        print(sys.argv[0] + ": please put your github username and password, separated by a colon, in the file ~/.cache/clean-github-pr-creds")
        sys.exit(1)

    # just to be sure
    os.chmod(CREDS_FILE, 0o600)

    # make the fork
    creds = f.readline()
    username = creds.split(":")[0]
    pword = creds.split(":")[1].strip()
    token = f.readline().strip()

    if len(token) != 0:
        g = github.Github(token)
    else:
        g = github.Github(username, pword)

    u = g.get_user()

    source = sys.argv[1]
    if '/' in source:
        fork = sys.argv[1].split("/")[1]
        print("forking repo " + source)
        u.create_fork(g.get_repo(source))
    else:
        fork = sys.argv[1]

    while True:
        try:
            r = u.get_repo(fork)
        except github.UnknownObjectException:
            print("still waiting")
            time.sleep(5)
        else:
            break

    # set up & push github branch
    user_work_dir = os.getcwd()
    work_area = tempfile.mkdtemp()
    os.chdir(work_area)
    subprocess.call(["git", "clone", "https://github.com/" + username + "/" + fork])
    os.chdir(work_area + "/" + fork)
    subprocess.call(["git", "checkout", "--orphan", "github"])
    subprocess.call(["git", "rm", "-rf", "."])
    with open("README.md", 'w') as f:
        f.write("This repository is just a fork made in order to submit a pull request; please ignore.")
    subprocess.call(["git", "add", "README.md"])
    subprocess.call(["git", "commit", "-m", "fork for a pull request; please ignore"])
    subprocess.call(["git", "push", "origin", "+github"])
    os.chdir(user_work_dir)
    shutil.rmtree(work_area)

    # make sure the branch has been pushed
    time.sleep(5)

    # set clean repository settings
    r.edit(fork,
           has_wiki=False,
           description="Fork for a pull request; please ignore",
           homepage="",
           has_issues=False,
           has_downloads=False,
           default_branch="github")

if __name__ == "__main__":
    main()
