source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'dotenv-rails'
gem 'env_bang-rails'

gem 'rails', '~> 5.2.1'

gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails_semantic_logger'

# gem 'devise'
gem 'phony_rails'
gem 'slack-notifier'

# ADMIN

gem 'activeadmin', '~> 1.3.1'
gem 'activeadmin_json_editor'

# API

gem 'grape'
gem 'grape_logging'
gem 'grape-entity' #, '0.6.0' # 0.6.1 depends on AS 5.0
gem 'grape-swagger', github: 'ruby-grape/grape-swagger' # Very problematic gem
gem 'grape-swagger-entity', github: 'ruby-grape/grape-swagger-entity' # see https://github.com/ruby-grape/grape-swagger/issues/424
gem 'httparty'
gem 'jwt'
gem 'rack-cors', :require => 'rack/cors'
gem 'rack-request-id'
gem 'warden'
gem 'yajl-ruby', require: 'yajl' #, github: 'vanburg/yajl-ruby', branch: 'drop-deprecation-warning' # A streaming JSON C-parsing

# ASSETS

gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# TOOLS

gem 'pry-rails'
gem 'database_rewinder', require: false # Used for rake db:seed in production too
gem 'factory_bot', require: false # Used for rake db:seed in production too
gem 'whenever', require: false

group :development, :test do
  gem 'launchy'
end

group :development do
  gem 'annotate' # use rake annotate_models | rake remove_annotation if want to force annotation
  gem 'awesome_print'
  gem 'foreman'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'json_expressions'
  gem 'rspec-rails'
  gem 'webmock'
end

