class CreatePrivileges < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.table_exists? 'privileges'
      create_table :privileges do |t|
        t.string :overview, default: 'R'
        t.string :tasks, default: 'R'
        t.string :notes, default: 'R'
        t.string :issues, default: 'R'
        t.string :admin, default: ''
        t.references :user, foreign_key: true
        t.timestamps
      end
    end
    begin
    User.find_each do |user|
      user.role = user.email == 'admin@example.com' ? :superadmin : :client
      user.privilege.create! unless user.privilege.present?
      user.save
    end
    rescue

    end
    begin
      remove_index :users, :privileges
      rename_column :users, :privileges, :old_privileges
    rescue

    end

  end
end
