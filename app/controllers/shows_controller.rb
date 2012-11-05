class ShowsController < ApplicationController
  authorize_resource :class => false

  def index
    @tours = Tour.where("end_on > ?", Date.today)
  end
end