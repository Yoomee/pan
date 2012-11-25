class AddAddressToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :address1, :string
    add_column :performers, :address2, :string
    add_column :performers, :city, :string
    add_column :performers, :postcode, :string
    add_column :performers, :country, :string
  end
end
