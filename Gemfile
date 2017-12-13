source 'https://rubygems.org'
ruby File.read(File.join File.dirname(__FILE__), '.ruby-version').strip

gem 'rails', '< 5'
gem 'jbuilder'

group :doc do
  gem 'sdoc', require: false
end

gem 'dalli'
gem 'httpclient'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'sprockets'
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
