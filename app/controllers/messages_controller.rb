class MessagesController < ApplicationController

  include YmMessages::MessagesController

  def new    
    if @performer = Performer.find_by_id(params[:performer_id])
      recipient_ids = @performer.user_ids
      if recipient_ids == []
        flash[:error] = "You cannot send a message to the performer at this time because there is no administrator to receive the performer's messages."
        redirect_to :back
      end               
    elsif params[:user_id].present? && recipient = User.find_by_id(params[:user_id])
      recipient_ids = [recipient.id]
    else
      recipient_ids = nil      
    end
    if recipient_ids
      @message_thread = MessageThread.find_or_initialize_by_user_ids(recipient_ids + [current_user.id])
      if !@message_thread.new_record?
        @message = @message_thread.messages.build
        @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
        @last_message = @messages.first
        render :template => 'message_threads/show'
      else
        @message.recipient_ids = recipient_ids
      end
      @message.thread = @message_thread
      authorize! :create, @message      
    end
  end
end