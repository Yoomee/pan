class PerformersController < ApplicationController
  
  expose(:performers) {Performer.order('name')}
  expose(:performer)
  expose(:posts) {performer.posts.page(params[:page])}

  def create
    if performer.save
      flash_notice(performer)
      redirect_to(performer)
    else
      render :action => 'new'
    end
  end

  def destroy
    performer.destroy
    flash_notice(performer)
    redirect_to(performers_path)
  end
  
  def edit
  end
  
  def index
  end
  
  def new
  end
  
  def show
    
  end
  
  def update
    if performer.save
      flash_notice(performer)
      redirect_to(performer)
    else
      render :action => 'edit'
    end
  end
  
end