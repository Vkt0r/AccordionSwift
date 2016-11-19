#!/bin/sh


if [[ "${TRAVIS_BRANCH}" == "swift-3"]]; then
   gem install bundler
   bundle install
   bundle exec fastlane test
   exit $?
fi

if [[ "TRAVIS_PULL_REQUEST" != false]]; then
   gem install bundler
   bundle install
   bundle exec fastlane test
   exit $?
fi
