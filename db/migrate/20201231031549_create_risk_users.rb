class CreateRiskUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_users do |t|
      t.references :user, foreign_key: true
      t.references :risk, foreign_key: true
      t.string :timestamps
    end
  end
end
