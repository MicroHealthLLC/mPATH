class CreateQueryFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :query_filters do |t|
      t.string :name
      t.string :filter_key
      t.text :filter_value
      t.integer :project_id

      t.timestamps
    end
  end
end
