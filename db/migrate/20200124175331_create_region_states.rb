class CreateRegionStates < ActiveRecord::Migration[5.2]
  def change
    create_table :region_states do |t|
      t.references :facility_group, foreign_key: true
      t.references :state, foreign_key: true
      t.timestamps
    end
  end
end
