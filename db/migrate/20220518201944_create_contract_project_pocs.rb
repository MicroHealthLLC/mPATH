class CreateContractProjectPocs < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_project_pocs do |t|
      t.string :name
      t.string :poc_type
      t.string :email
      t.string :title
      t.string :work_number
      t.string :mobile_number
      t.string :notes

      t.timestamps
    end
  end
end
