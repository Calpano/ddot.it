#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# On macOS, native gem extensions need the SDK headers (stdio.h etc.)
# and Homebrew OpenSSL to be explicitly visible.
if [[ "$(uname)" == "Darwin" ]]; then
  export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
  if command -v brew &>/dev/null; then
    bundle config set build.eventmachine \
      --with-openssl-dir="$(brew --prefix openssl)"
  fi
fi

echo "Installing gems..."
bundle install

echo "Starting Jekyll at http://localhost:4000 ..."
bundle exec jekyll serve --livereload --incremental
