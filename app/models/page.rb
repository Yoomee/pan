class Page < ActiveRecord::Base
  include YmCms::Page
  has_snippets :summary
  
end