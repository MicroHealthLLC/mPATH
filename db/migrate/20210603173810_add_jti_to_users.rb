class AddJtiToUsers < ActiveRecord::Migration[6.1]
  def change
    # https://github.com/waiting-for-dev/devise-jwt#jtimatcher
    add_column :users, :jti, :string
    User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true
  end
end
