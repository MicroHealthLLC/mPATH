class RemoveNotNullConstrain < ActiveRecord::Migration[6.1]
  def change
    change_column_null :facilities, :email, true, nil
  end
end
