source 'http://rubygems.org'

### Always used
gem 'rails', '3.1.0'
gem 'mysql2'
gem "rake", "0.8.7"

### Frequently used
gem 'exception_notification'
gem 'formtastic-bootstrap', :git => "git://github.com/cgunther/formtastic-bootstrap.git", :branch => "bootstrap-2"

### Yoomee gems
# gem 'ym_core', :git => "git://git.yoomee.com:4321/gems/ym_core.git"
# gem 'ym_cms', :git => "git://git.yoomee.com:4321/gems/ym_cms.git"
# gem 'ym_permalinks', :git => "git://git.yoomee.com:4321/gems/ym_permalinks.git"
# gem 'ym_users', :git => "git://git.yoomee.com:4321/gems/ym_users.git"

def ym_gem(gem_name)
 return true unless gem_name
 if !File.directory?(gem_path = "vendor/gems/#{gem_name}")
   system("git clone -q git://git.yoomee.com:4321/gems/#{gem_name}.git #{gem_path}")
 end
 gem gem_name, :path => "vendor/gems"
end

### Yoomee gems
ym_gem 'ym_core'
ym_gem 'ym_cms'
ym_gem 'ym_permalinks'
ym_gem 'ym_users'
ym_gem 'ym_tags'
ym_gem 'ym_posts'

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