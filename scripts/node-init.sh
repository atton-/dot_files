#!/bin/bash

nodenv_before_install() {
    nodenv rehash
    prefix=$(nodenv prefix)
    echo "cache = $prefix/.npm" > "$prefix/lib/node_modules/npm/npmrc"
}

nodenv_after_install() {
    nodenv rehash
}

install_packages() {
    npm install --global npm
    npm install --global neovim typescript yarn
}

type nodenv >& /dev/null;
check_nodenv=$?

set -eux

type node npm
node --version
npm --version

if [ $check_nodenv -eq 0 ]; then nodenv_before_install; fi
install_packages
if [ $check_nodenv -eq 0 ]; then nodenv_after_install; fi
