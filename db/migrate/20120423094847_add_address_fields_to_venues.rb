class AddAddressFieldsToVenues < ActiveRecord::Migration
  def change
    cols = %w{address1 address2 city region postcode lat lng}
    cols.reverse.each do |col|
      add_column :venues, col, :string, :after => :description
    end
  end
end
