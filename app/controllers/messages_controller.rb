class MessagesController < ApplicationController

  include YmMessages::MessagesController

  def new
    recipient_ids = get_recipient_ids
    if recipient_ids.blank?
      flash[:error] = no_recipients_message
      redirect_to :back
    else
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

  private
  def get_recipient_ids
    if @performer = Performer.find_by_id(params[:performer_id])
      @performer.user_ids
    elsif @promoter = Promoter.find_by_id(params[:promoter_id])
      @promoter.user_ids
    elsif @user = User.find_by_id(params[:user_id])
      [@user.id]
    end
  end

  def no_recipients_message
    if @performer
      "You cannot send a message to the performer at this time because there is no administrator to receive the performer's messages."
    elsif @promoter
      "You cannot send a message to the organisation at this time because there is no administrator to receive the promoter's messages."
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end