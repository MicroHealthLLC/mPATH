class CreateFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities do |t|
      t.string :facility_name, null: false, default: ""
      t.string :address
      t.string :point_of_contact
      t.string :phone_number
      t.string :email, null: false, default: ""
      t.text :notes
      
      t.timestamps
    end
  end
end
