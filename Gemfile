source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "acts-as-taggable-on"
gem "dotenv-rails"
gem "dragonfly"
gem "cssbundling-rails"
gem "devise"
gem "haml"
gem "jsbundling-rails"
gem "kaminari"
gem "kramdown" # import
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.1"
gem "sprockets-rails"
gem "sqlite3"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
