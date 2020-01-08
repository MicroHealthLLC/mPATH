class AddCreatorInFacilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities, :creator, foreign_key: { to_table: :users }
  end
end
