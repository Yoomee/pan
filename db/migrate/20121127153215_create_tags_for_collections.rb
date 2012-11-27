class CreateTagsForCollections < ActiveRecord::Migration
  def up
    ns = Tag.create(:name => "Network Supported")
    gs = Tag.create(:name => "Go See")
    yp = Tag.create(:name => "Young Promoters")

    execute "INSERT INTO taggings(tag_id, taggable_id, taggable_type, context, created_at) VALUES (#{ns.id}, 51, 'Tour', 'collections', CURRENT_TIMESTAMP())"
    execute "INSERT INTO taggings(tag_id, taggable_id, taggable_type, context, created_at) VALUES (#{gs.id}, 51, 'Tour', 'collections', CURRENT_TIMESTAMP())"
    execute "INSERT INTO taggings(tag_id, taggable_id, taggable_type, context, created_at) VALUES (#{yp.id}, 51, 'Tour', 'collections', CURRENT_TIMESTAMP())"
  end

  def down
  end
end
