class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.integer :status, default: 0
      t.integer :project_type
      t.string :name
      t.text :description
      t.references :facility, foreign_key: true
      t.timestamps
    end
  end
end
