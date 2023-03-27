class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_portfolio, default: false
      t.boolean :is_default, default: false
      t.string :type_of

      t.timestamps
    end
  end
end
