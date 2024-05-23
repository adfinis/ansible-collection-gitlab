#!/usr/bin/env sh

python3 -m venv $(dirname "$0")/venv/

PIP=$(dirname "$0")/venv/bin/pip

$PIP install ansible-dev-tools