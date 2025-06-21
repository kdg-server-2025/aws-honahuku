#!/usr/bin/env bash
set -Ceux
set -o pipefail

# GitHub に登録した公開鍵をダウンロードする
GITHUB_USERNAME="honahuku"
if ! wget --tries=50 --waitretry=10 --connect-timeout=10 -O authorized_keys https://github.com/${GITHUB_USERNAME}.keys
then
  # SSH の公開鍵を配置する
  mkdir -p ~/.ssh/
  mv authorized_keys ~/.ssh/

  # sshd が使えるようにするために鍵のパーミッションを変更する
  chmod 600  ~/.ssh/authorized_keys
  exit 0
else
  exit 1
fi
