#!/bin/bash
set -exo pipefail

# mktemp で作業用のディレクトリを作成 (カレントディレクトリが汚れないようにするため, 不要なファイルが zip に入らないようにするため)
TEMPDIR=$(mktemp -d)
# 各自のバケット名に書き換え
ARTIFACT_BUCKET="kdg-aws-2025-honahuku-lambda-artifacts"

# # ソースコードをzipファイルに追加
cd function
go build -tags lambda.norpc -o bootstrap main.go

# function ディレクトリごと zip に含めてしまうのでここで実行
zip "$TEMPDIR"/deployment-package.zip -r ./bootstrap

cd ..

# S3にアップロードしてlambda関数の参照を書き換える
aws s3 cp "$TEMPDIR"/deployment-package.zip s3://$ARTIFACT_BUCKET/
aws lambda update-function-code --no-cli-pager --function-name first-function --s3-bucket $ARTIFACT_BUCKET --s3-key deployment-package.zip

# デプロイ時の一時ファイルを削除
rm -rf "$TEMPDIR"
