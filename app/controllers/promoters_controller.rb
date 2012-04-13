class PromotersController < ApplicationController

  expose(:promoters) {Promoter.order('name')}
  expose(:promoter)
  expose(:posts) {promoter.posts.page(params[:page])}
  
  def create
    if promoter.save
      flash[:notice] = 'Created new promoter'
      redirect_to(promoter)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    promoter.destroy
    flash[:notice] = "Deleted promoter, #{promoter}"
    redirect_to(promoters_path)
  end
  
  def edit;end
  
  def index;end
  
  def new;end

  def show;end
  
  def update
    if promoter.save
      flash[:notice] = 'Updated promoter'
      redirect_to(promoter)
    else
      render :action => 'edit'
    end
  end
  
end