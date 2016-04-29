source 'https://rubygems.org'

gem 'rails', '>= 5.0.0.beta3', '< 5.1'
gem 'pg', '~> 0.18'
gem 'puma'

gem 'active_model_serializers', '~> 0.10.0.rc5'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'pundit', '~> 1.1.0'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.5.0.beta3'
  gem 'json_spec', '~> 1.1.4'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1.1'
  gem 'factory_girl_rails', '~> 4.7.0'
end

group :production do
  gem 'rails_12factor'
end
