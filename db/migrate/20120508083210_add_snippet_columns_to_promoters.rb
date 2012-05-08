class AddSnippetColumnsToPromoters < ActiveRecord::Migration
  
  def self.up
    cols = %w{phone email address1 address2 city region postcode lat lng}
    cols.reverse.each do |col|
      add_column :promoters, col, :string, :after => :description
    end
    Promoter.reset_column_information
    old_cols = %w{phone email address1 address2 address3 region postcode}
    Snippet.where(["item_type = 'Promoter' AND name IN (?)", old_cols]).each do |snippet|
      if promoter = Promoter.find_by_id(snippet.item_id)
        col_name = snippet.name=='address3' ? 'city' : snippet.name
        promoter.update_attribute(col_name, snippet.text)
      end
    end
  end

  def self.down
    cols = %w{phone email address1 address2 city region postcode lat lng}
    cols.reverse.each do |col|
      remove_column :promoters, col
    end
  end
  
end
