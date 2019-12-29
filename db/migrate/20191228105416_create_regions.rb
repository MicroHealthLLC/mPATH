class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :position
      t.string :boundary
      t.string :color

      t.timestamps
    end
  end
end
