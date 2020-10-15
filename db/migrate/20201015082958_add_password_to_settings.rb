class AddPasswordToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :passwords_key, :text
  end
end
