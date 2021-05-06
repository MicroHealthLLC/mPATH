class CreateFacilityPrivileges < ActiveRecord::Migration[6.1]
  def change
    create_table :facility_privileges do |t|
      t.string :overview, default: "R"
      t.string :tasks, default: "R"
      t.string :notes, default: "R"
      t.string :issues, default: "R"
      t.string :admin, default: "R"
      t.string :risks, default: "R"
      t.integer :user_id
      t.integer :facility_project_id
      t.integer :facility_id
      t.timestamps
    end
  end
end
