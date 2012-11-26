class MessagesController < ApplicationController
  load_and_authorize_resource :only => :create
  authorize_resource

  def create
    if thread = current_user.threads.joins('JOIN thread_participants AS tp2 ON tp2.message_thread_id = message_threads.id ').where('tp2.participant_id = ?', params[:message][:recipient_id]).first
    else
      thread = MessageThread.create
      thread.participants << [current_user, User.find(params[:message][:recipient_id])]
    end

    if thread.messages.create(:user => current_user, :text => params[:message][:text])
      flash.notice = "Your message has been sent"
    else
      flash.error = "Something went wrong - your message has not been sent"
    end
    redirect_to current_user
  end

  def index
    @user = current_user
    @threads = @user.threads 
  end

  def show
    @user = current_user
    @thread = MessageThread.find(params[:id])
  end

end