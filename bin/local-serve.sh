#!/bin/sh
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
cd "$(dirname "$0")/.."
exec bundle exec jekyll serve --host 127.0.0.1 --port 4000
