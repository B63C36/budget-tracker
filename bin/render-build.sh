#!/bin/bash
set -e

bundle install
bundle exec rails db:migrate
# bundle exec rails db:seed     # uncomment only if you want seed data every deploy