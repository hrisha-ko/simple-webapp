#!/usr/bin/env bash

latest_version="$(curl -sIL https://github.com/snyk/snyk/releases/latest | grep "^location:" |grep "tag" | sed 's/[^v0-9.]*//g' | cut -c 2-)"
echo "Latest Snyk CLI Version: ${latest_version}"
snyk_cli_dl_linux="https://github.com/snyk/snyk/releases/download/${latest_version}/snyk-linux"
echo "Download URL: ${snyk_cli_dl_linux}"
curl -Lo ./snyk "${snyk_cli_dl_linux}"
chmod +x snyk
ls -la
./snyk -v