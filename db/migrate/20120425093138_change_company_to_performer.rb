class ChangeCompanyToPerformer < ActiveRecord::Migration
  
  def self.up
    rename_table :companies, :performers
    rename_column :tours, :company_id, :performer_id
    Post.where("target_type = 'Company'").update_all("target_type = 'Performer'")
    ActsAsTaggableOn::Tagging.where("taggable_type = 'Company'").update_all("taggable_type = 'Performer'")
  end

  def self.down
    ActsAsTaggableOn::Tagging.where("taggable_type = 'Performer'").update_all("taggable_type = 'Company'")    
    Post.where("target_type = 'Performer'").update_all("target_type = 'Company'")
    rename_column :tours, :performer_id, :company_id    
    rename_table :performers, :companies    
  end
  
end
