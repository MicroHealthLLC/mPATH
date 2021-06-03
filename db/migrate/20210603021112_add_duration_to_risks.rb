class AddDurationToRisks < ActiveRecord::Migration[6.1]
  def change
    add_column :risks, :duration, :integer
  end
end
