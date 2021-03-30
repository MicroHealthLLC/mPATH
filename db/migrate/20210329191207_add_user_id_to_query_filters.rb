class AddUserIdToQueryFilters < ActiveRecord::Migration[5.2]
  def change
    add_column :query_filters, :user_id, :integer
    add_index :query_filters, :user_id
  end
end
