source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.3.2' #'~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
gem "puma", ">= 4.3.8"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap', '~> 4.3.1'
gem 'slim-rails'
gem 'jquery-rails'
gem 'devise', '~> 4.7.1'
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'cancancan'
gem 'geocoder'
gem "omniauth-office365", github: 'jcarbo/omniauth-office365'
gem 'omniauth-google-oauth2'
# gem 'omniauth-oktaoauth'
gem 'dotenv-rails'
gem 'strip_attributes'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'cypress-on-rails', '~> 1.0'
  gem 'letter_opener'
  # gem 'bullet', '6.1.0'
  gem 'pry', '~> 0.13.1'
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'active_record_doctor'
  gem 'sql_tracker'
  gem 'fasterer'
end

group :production do
 # gem 'pg', '>= 0.18', '< 2.0'
end
# To give memory back to operating system
gem 'malloc_trim'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#Activerecord-Import is a library for bulk inserting data using ActiveRecord.
gem 'activerecord-import', '1.0.7'


gem 'omniauth-rails_csrf_protection', '~> 0.1'

# Easy cloning of active_record objects including associations and several operations under associations and attributes.
gem 'amoeba'

gem 'ledermann-rails-settings'

gem 'oj'

gem 'will_paginate', '~> 3.1.0'

gem "addressable", ">= 2.8.0"
