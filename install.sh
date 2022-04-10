#!/usr/bin/env bash

set -e

BASEDIR=$HOME/Developer/dotfiles

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
#BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#cd "${BASEDIR}"

[ -d "$BASEDIR" ] || git clone git@github.com:QWxleA/dotfiles.git "$BASEDIR"
cd "$BASEDIR"

git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

