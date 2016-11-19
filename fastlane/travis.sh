#!/bin/sh
bundle install
bundle exec fastlane test
exit $?

#if [[ "TRAVIS_PULL_REQUEST" != false]]; then
#   gem install bundler
#   bundle install
#   bundle exec fastlane test
#   exit $?
#fi
