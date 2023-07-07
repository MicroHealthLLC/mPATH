class AddProjectedHourField < ActiveRecord::Migration[6.1]
  def change
    add_column :efforts, :projected, :boolean, default: false
  end
end
