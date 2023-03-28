#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /home/deploy/app/tmp/pids/server.pid

bundle exec puma