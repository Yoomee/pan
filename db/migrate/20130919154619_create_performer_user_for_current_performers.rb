class CreatePerformerUserForCurrentPerformers < ActiveRecord::Migration
  def up
    User.where('performer_id IS NOT NULL').each do |user|
      PerformerUser.create(:performer_id => user.performer_id, :user_id => user.id)
    end
  end

  def down
    PerformerUser.order(:created_at).each do |performer_user|
      User.find(performer_user.user_id).update_attributes(:performer_id => performer_user.performer_id)
    end
  end
end
