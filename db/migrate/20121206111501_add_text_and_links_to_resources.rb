class AddTextAndLinksToResources < ActiveRecord::Migration
  
  def change
    add_column :resources, :text, :text, :after => :summary
    add_column :resources, :url, :string, :after => :text
  end
end
