#!/bin/sh

if [[ "${CONFIGURATION}" != "Debug" ]]; then
    exit 0
fi

if [[ "$(uname -m)" == arm64 ]]
then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if command -v swiftlint >/dev/null 2>&1
then
    swiftlint --fix --no-cache
else
    echo "warning: `swiftlint` command not found - See https://github.com/realm/SwiftLint#installation for installation instructions."
fi