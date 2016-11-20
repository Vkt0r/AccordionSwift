#!/bin/sh


if [[ "TRAVIS_PULL_REQUEST" != false ]]; then
  cd Example/
  bundle install
  bundle exec fastlane test
  exit $?
fi
