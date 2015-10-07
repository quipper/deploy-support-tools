source 'https://rubygems.org'
ruby File.read(File.join File.dirname(__FILE__), '.ruby-version').strip

gem 'rails', '~> 4.1.13'
gem 'jbuilder', '~> 1.2'

group :doc do
  gem 'sdoc', require: false
end

gem 'dalli'
gem 'hipchat'
gem 'httpclient'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'sprockets', '=2.11.0'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'octokit'

group :production do
  gem 'memcachier'
  gem 'unicorn'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'pry-byebug'
  gem 'timecop'
  gem 'dotenv-rails'
end
