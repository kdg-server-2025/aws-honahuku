#!/usr/bin/env bash
set -Ceux
set -o pipefail

# GitHub に登録した公開鍵をダウンロードする
GITHUB_USERNAME="honahuku"
wget https://github.com/${GITHUB_USERNAME}.keys

# SSH の公開鍵を配置する
mkdir -p ~/.ssh/
mv ${GITHUB_USERNAME}.keys ~/.ssh/authorized_keys

# sshd が使えるようにするために鍵のパーミッションを変更する
chmod 600  ~/.ssh/authorized_keys
