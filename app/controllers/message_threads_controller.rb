class MessageThreadsController < ApplicationController

  include YmMessages::MessageThreadsController

  def set_thread_to_read
    @message_thread.set_read!(current_user)
    render :nothing => true
  end

end