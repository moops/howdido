source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'
gem 'rails', '~> 5.2.0.beta2'

gem 'bootstrap'
gem 'pg'                        # postgres as the database for Active Record

gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'jbuilder'                  # https://github.com/rails/jbuilder
gem 'jquery-rails'
gem 'json'                      # json api
gem 'kaminari'                  # pagination
gem 'uglifier'                  # javascript compressor

gem 'bcrypt'                    # needed for has_secure_password
gem 'pundit'                    # authorization

gem 'byebug',             group: %i[development test]
gem 'factory_bot_rails',  group: %i[development test]
gem 'rspec-rails',        group: %i[development test]

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
