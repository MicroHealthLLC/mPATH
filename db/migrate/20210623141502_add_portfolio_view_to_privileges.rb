class AddPortfolioViewToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :portfolio_view, :string, default: "R"
  end
end
