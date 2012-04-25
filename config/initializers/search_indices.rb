Performer.define_index do
  indexes name, :sortable => true
  indexes description
  has created_at, updated_at
end
