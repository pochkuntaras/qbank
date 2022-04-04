# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'active_model_serializers'
gem 'bootsnap', require: false
gem 'database_cleaner'
gem 'dry-validation'
gem 'interactor', '~> 3.0'
gem 'interactor-contracts'
gem 'oj'
gem 'oj_mimic_json'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
gem 'sidekiq', '~> 6.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'annotate'
  gem 'spring'
end

group :test do
  gem 'dry-validation-matchers'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 5.0'
end
