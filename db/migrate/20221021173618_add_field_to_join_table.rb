class AddFieldToJoinTable < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_project_poc_resources, :poc_type, :string
  end
end
