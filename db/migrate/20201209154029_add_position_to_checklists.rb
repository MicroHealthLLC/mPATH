class AddPositionToChecklists < ActiveRecord::Migration[5.2]
  def change
    add_column :checklists, :position, :integer, default: 0
  end
end
