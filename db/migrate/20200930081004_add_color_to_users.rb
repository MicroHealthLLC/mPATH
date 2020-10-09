class AddColorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :color, :string

    begin
      User.find_each do |user|
        user.color = "##{SecureRandom.hex(3)}"
        user.save
      end
    rescue
    end
  end
end
