class PagesController < ApplicationController
  
  include YmCms::PagesController
  load_and_authorize_resource
  
end