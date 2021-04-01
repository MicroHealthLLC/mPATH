class AddFavoriteFilterIdToQueryFilters < ActiveRecord::Migration[5.2]
  def change
    add_column :query_filters, :favorite_filter_id, :integer
  end
end
