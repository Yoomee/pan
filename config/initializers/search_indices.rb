Page.define_index do
  where sanitize_sql(["published", true])
  indexes title, :sortable => true
  indexes text
  has parent_id, published, view_name, created_at, updated_at
end
