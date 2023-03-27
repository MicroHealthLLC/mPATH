class AddIgnoreStatusToContract < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_project_data, :ignore_expired, :boolean, default: :false
  end
end
