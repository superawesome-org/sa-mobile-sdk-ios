source "https://rubygems.org"

gem "json"
gem "fastlane"
gem "cocoapods"
gem "cocoapods-check"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
