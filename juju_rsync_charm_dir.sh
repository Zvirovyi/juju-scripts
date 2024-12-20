#!/bin/bash

set -e

if [[ -z "$1" ]]; then
  echo "source path is not specified" >&2
  exit 1
fi

if [[ -z "$2" ]]; then
  echo "destination path is not specified" >&2
  exit 1
fi

rsync -r --exclude .tox --exclude .github --exclude .idea --exclude .ruff_cache --exclude docs --exclude venv --exclude .coverage --exclude .gitignore --exclude \*.md --exclude icon.svg "$1" "$2"