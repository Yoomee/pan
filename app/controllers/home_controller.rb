class HomeController < ApplicationController

  def index
    if current_user
      if Page.find_by_slug(:noticeboard)
        @pages = Page.find_by_slug(:noticeboard).children
      else
        @pages = []
      end
      @latest_shows = Tour.order(:created_at).reverse_order.limit(5)
      @upcoming_events = TourDate.in_pan_venue.future.order(:date).limit(3)
      @recent_activity = YmActivity::ActivityItem.paginate(:per_page => 3, :page => params[:page])
      @tours = Tour.where("performer_id = #{current_user.performer.id}") if current_user.performer
      render :index
    else
      redirect_to sign_in_path
    end
  end

  def renew

  end
  
  def welcome
    index
  end

end