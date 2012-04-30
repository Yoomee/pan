class AddPublicationDateToResources < ActiveRecord::Migration
  def change
    add_column :resources, :publication_date, :string, :after => :summary
  end
end
