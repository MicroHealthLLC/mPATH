class CreateFavoriteFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_filters do |t|
      t.string :name
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_default, default: false
      t.boolean :shared
      t.boolean :private

      t.timestamps
    end
  end
end
