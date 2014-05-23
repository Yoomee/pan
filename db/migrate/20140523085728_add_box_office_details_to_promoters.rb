class AddBoxOfficeDetailsToPromoters < ActiveRecord::Migration
  def change
    add_column :promoters, :ticket_price_full, :float
    add_column :promoters, :ticket_price_concession, :float
    add_column :promoters, :ticket_price_other, :float
    add_column :promoters, :ticket_link, :string
  end
end
