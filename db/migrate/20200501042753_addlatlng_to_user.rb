class AddlatlngToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lat, :string
    add_column :users, :lng, :string
  end
end
