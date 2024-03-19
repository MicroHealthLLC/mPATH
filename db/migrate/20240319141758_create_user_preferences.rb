class CreateUserPreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :user_preferences do |t|
      t.string :navigation_menu, default:  'map'
      t.string :sub_navigation_menu
      t.integer :program_id
      t.integer :project_id
      t.integer :project_group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
