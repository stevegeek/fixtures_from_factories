#!/bin/sh

SECRET_KEY_BASE=base RAILS_ENV=fixtures_from_factories bundle exec rails runner generate_demo_data.rb
