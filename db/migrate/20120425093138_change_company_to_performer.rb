class ChangeCompanyToPerformer < ActiveRecord::Migration
  def change
    rename_table :companies, :performers
    rename_column :tours, :company_id, :performer_id
  end
end
