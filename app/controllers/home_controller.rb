class HomeController < ApplicationController

  def index
    if current_user
      @pages = Page.find_by_slug(:noticeboard).children
      render :index
    else
      redirect_to sign_in_path
    end
  end


end