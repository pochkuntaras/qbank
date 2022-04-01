# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false
gem 'rack-cors'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 5.0.0'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'annotate'
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end
