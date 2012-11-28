class CollectionsController < ApplicationController
  load_and_authorize_resource

  def create
    if @collection.save
      flash.notice = "#{@collection} has been created."
      redirect_to collections_path
    else
      flash.error = "Something has gone wrong - please try again."
      render :new
    end
  end

  def destroy
    if @collection.delete
      flash.notice = "#{@collection} has been deleted."
    else
      flash.error = "Something has gone wrong - #{@collection} has not been deleted - please try again."
    end
    redirect_to collections_path
  end

  def edit
  end

  def index
  end

  def update
    if @collection.update_attributes(params[:collection])
      flash.notice = "#{@collection} has been updated."
      redirect_to collections_path
    else
      flash.error = "Something has gone wrong - please try again."
      render :edit
    end
  end

end