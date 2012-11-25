class HomeController < ApplicationController

  def index
    if current_user
      if Page.find_by_slug(:noticeboard)
        @pages = Page.find_by_slug(:noticeboard).children
      else
        @pages = []
      end  
      render :index
    else
      redirect_to sign_in_path
    end
  end


end