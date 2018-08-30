source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'dotenv-rails'
gem 'env_bang-rails'

gem 'rails', '~> 5.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb

gem 'devise'
gem 'phony_rails'

# ADMIN

gem 'activeadmin'
gem 'activeadmin_json_editor'

# API

gem 'grape'
gem 'grape_logging'
gem 'grape-entity' #, '0.6.0' # 0.6.1 depends on AS 5.0
gem 'grape-swagger', github: 'ruby-grape/grape-swagger' # Very problematic gem
gem 'grape-swagger-entity', github: 'ruby-grape/grape-swagger-entity' # see https://github.com/ruby-grape/grape-swagger/issues/424
gem 'rack-cors', :require => 'rack/cors'

# ASSETS

gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# TOOLS

gem 'pry-rails'

group :development do
  gem 'annotate' # use rake annotate_models | rake remove_annotation if want to force annotation
  gem 'awesome_print'
  gem 'foreman'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
