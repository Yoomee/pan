class MessageThread < ActiveRecord::Base

  include YmMessages::MessageThread

  def unread_count(user)
    MessageThread.find(id).thread_users.where(:read => 0).where(:user_id => user.id).count
  end

end