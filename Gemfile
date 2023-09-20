source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.0"
# Use Puma as the app server
gem "puma", ">= 5.6.2"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
gem "vite_rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Mongo gem
gem "mongoid"
# Mints gems
gem "mints", "~> 0.0.33"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
# Used to optimize deployment time
gem "sassc"
# Google chat notification
gem "hangouts-chat"
# Interactor
gem 'interactor', "~> 3.0"

group :production do
  gem "stackdriver"
  gem "google-cloud-error_reporting"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "standard"
  gem "standard"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Capistrano
gem "capistrano", "~> 3.11"
gem "capistrano-rails", "~> 1.4"
gem "capistrano-passenger", "~> 0.2.0"
gem "capistrano-rbenv", "~> 2.1", ">= 2.1.4"

# Dotenv
gem "dotenv-rails", groups: [:development, :test]
gem "mimemagic", "~> 0.3.6"
# Security
gem "rack-headers_filter"

gem 'rack-cors'

gem 'pusher'
