# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'rubyzip'

gem 'rake'

group :development do
  gem 'rubocop'
  gem 'rubocop-performance', require: false
end

group :test do
  gem 'test-unit', require: false
  gem 'simplecov', require: false
  gem 'webmock', require: false
end
