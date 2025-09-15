# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

gem 'bcrypt'
gem 'importmap-rails'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
gem 'rails', '~> 8.0.2'
gem 'stimulus-rails'
gem 'turbo-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false
# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

gem 'database_validations'
gem 'devise'
gem 'dotenv'
gem 'pagy', '~> 9.3'
gem 'premailer-rails'
gem 'rack-cors'
gem 'rails_app_version'
gem 'ransack'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'strong_migrations'

gem 'dry-matcher'
gem 'dry-monads'
gem 'dry-rails', '~> 0.3'

group :development do
  gem 'amazing_print'
  gem 'annotaterb'
  gem 'bundler-audit', require: false
  gem 'erb_lint', require: false
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 2.0'
  gem 'web-console'
end

group :development, :test do
  gem 'bullet'
  gem 'faker'
  gem 'i18n-tasks', '~> 1.0.13'
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'dotenv-rails'
  gem 'rubocop', '~> 1.48', require: false
  gem 'rubocop-i18n', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'syntax_suggest'
end

group :test do
  gem 'airborne'
  gem 'factory_bot_rails'
  gem 'n_plus_one_control'

  gem 'rspec_junit_formatter', require: false
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false

  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
  gem 'webmock'
end
