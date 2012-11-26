source 'https://yoomee:wLjuGMTu30AvxVyIrq3datc73LVUkvo@gems.yoomee.com'
source 'http://rubygems.org'

### Always used
gem 'rails', '3.1.0'
gem 'mysql2'
gem "rake", "0.8.7"

### Frequently used
gem 'exception_notification'
gem 'country-select'
gem 'formtastic-bootstrap', :git => "git://github.com/cgunther/formtastic-bootstrap.git", :branch => "bootstrap-2"
gem 'whenever', :require => false

gem 'geocoder'
gem 'cocoon'
gem 'datetimespan'
gem 'newrelic_rpm'
gem 'ey_config'
  
gem 'mailcatcher'

gem 'ym_core', "~> 0.1.33" #, :path => "~/Rails/Gems/ym_core"
gem 'ym_videos', "~> 0.1"
gem 'ym_users', "~> 0.1"
gem 'ym_posts', "~> 0.1" #, :path => "~/Rails/Gems/ym_posts"
gem 'ym_search', "~> 0.1"
gem 'ym_tags', "~> 0.1" #, :path => "~/Rails/Gems/ym_tags"
gem 'ym_permalinks', "~> 0.1"
gem 'ym_docs', "~> 0.1"
gem 'ym_cms', "~> 0.1"
gem 'ym_enquiries', "~> 0.1"
gem 'ym_notifications', "~> 0.1"

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
 gem 'ruby-debug19', :require => 'ruby-debug'
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