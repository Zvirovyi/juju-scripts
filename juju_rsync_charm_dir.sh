#!/bin/bash

set -e

rsync -r --exclude .git --exclude .tox --exclude .github --exclude .idea --exclude .ruff_cache --exclude docs --exclude venv --exclude .coverage --exclude .gitignore --exclude .jujuignore --exclude \*.md --exclude icon.svg --exclude LICENSE $1 $2