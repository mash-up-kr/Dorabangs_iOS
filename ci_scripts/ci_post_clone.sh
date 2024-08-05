#!/bin/zsh

# Install dependencies
brew install swiftlint swiftformat

curl https://mise.run | sh
echo 'export PATH="$HOME/.local/share/mise/shims:$PATH"' >> ~/.zprofile
mise activate --shims

# Run Tuist
cd ..
~/.local/bin/mise install
~/.local/bin/mise exec -- tuist install
~/.local/bin/mise exec -- tuist generate