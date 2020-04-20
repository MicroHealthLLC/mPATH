class AddStatusInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :integer, default: 1
  end
end
