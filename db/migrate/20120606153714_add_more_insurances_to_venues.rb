class AddMoreInsurancesToVenues < ActiveRecord::Migration

  def change
    add_column :venues, :volunteer_insurance, :boolean
    add_column :venues, :third_party_insurance, :boolean
  end

end
