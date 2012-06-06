class AddSummaryToOrganisations < ActiveRecord::Migration
  def change
    add_column :performers, :summary, :string
    add_column :promoters, :summary, :string
    add_column :venues, :summary, :string
  end
end
