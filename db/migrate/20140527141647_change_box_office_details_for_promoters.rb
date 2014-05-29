class ChangeBoxOfficeDetailsForPromoters < ActiveRecord::Migration
  def up
    remove_column :promoters, :ticket_price_full
    remove_column :promoters, :ticket_price_concession
    remove_column :promoters, :ticket_price_other
    remove_column :promoters, :ticket_link
    add_column :promoters, :box_office_phone, :string
    add_column :promoters, :box_office_email, :string
    add_column :promoters, :box_office_person, :string
    add_column :promoters, :box_office_online, :string
    add_column :tour_dates, :ticket_price_full, :float
    add_column :tour_dates, :ticket_price_concession, :float
    add_column :tour_dates, :ticket_price_other, :float
    add_column :tour_dates, :ticket_link, :string
  end

  def down
    remove_column :tour_dates, :ticket_price_full
    remove_column :tour_dates, :ticket_price_concession
    remove_column :tour_dates, :ticket_price_other
    remove_column :tour_dates, :ticket_link
    remove_column :promoters, :box_office_phone
    remove_column :promoters, :box_office_email
    remove_column :promoters, :box_office_person
    remove_column :promoters, :box_office_online
    add_column :promoters, :ticket_price_full, :float
    add_column :promoters, :ticket_price_concession, :float
    add_column :promoters, :ticket_price_other, :float
    add_column :promoters, :ticket_link, :string
  end
end
