require File.expand_path('../lib/ym_gem_loader', __FILE__) 

source 'http://rubygems.org'

### Always used
gem 'rails', '3.1.0'
gem 'mysql2'
gem "rake", "0.8.7"

### Frequently used
gem 'exception_notification'
gem 'formtastic-bootstrap', :git => "git://github.com/cgunther/formtastic-bootstrap.git", :branch => "bootstrap-2"

load_ym_gems!

### Groups
# Gems used only for assets and not required
# in production environments by default.
group :assets do
 gem 'sass-rails', "  ~> 3.1.0"
 gem 'coffee-rails', "~> 3.1.0"
 gem 'uglifier'
end

group :development do
 gem 'growl'
 gem 'ruby-debug19'
 gem 'yoomee', :git => "git://git.yoomee.com:4321/gems/yoomee.git", :branch => "rails3"
 # comment this when deploying
end

gem "rspec-rails", :group => [:test, :development]
group :test do
 gem "factory_girl_rails"
 gem 'shoulda-matchers'
 gem "capybara"
 gem "guard-rspec"
 #gem 'turn', :require => false
end