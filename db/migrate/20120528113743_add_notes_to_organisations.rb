class AddNotesToOrganisations < ActiveRecord::Migration
  def change
    [:performers, :promoters, :venues].each do |org|
      add_column org, :notes, :text
    end
  end
end
