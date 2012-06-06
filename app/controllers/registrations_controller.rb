class RegistrationsController < ApplicationController
  
  def new
    session[:user_params] ||= {}
    @user = User.new(session[:user_params])
    @user.current_step = session[:user_step]
  end
  
  def create
    params[:user] ||= {}
    if params[:organisation_type_performer]
      params[:user][:organisation_type] = "performer"
    elsif params[:organisation_type_promoter]
      params[:user][:organisation_type] = "promoter"
    end
    # Reject empty params to make going back easier
    params[:user].reject!{|k,v| v.blank?}
    session[:user_params].deep_merge!(params[:user]) if params[:user]
    @user = User.new(session[:user_params])
    @user.current_step = session[:user_step]
    if @user.valid?
      if params[:back_button]
        @user.previous_step
      elsif @user.last_step?
        @user.save if @user.all_valid?
      else
        @user.next_step
      end
      session[:user_step] = @user.current_step
    end
    if @user.new_record?
      render "new"
    else
      session[:user_step] = session[:user_params] = nil
      flash[:notice] = "Welcome to Tourbook"
      sign_in(@user)
      if @user.performer
        redirect_to @user.performer
      else
        redirect_to @user.promoter
      end
    end
  end
  
end