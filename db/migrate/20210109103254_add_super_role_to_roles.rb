class AddSuperRoleToRoles < ActiveRecord::Migration[5.2]
  def change
     begin
    add_column :roles, :system, :boolean, default: false
 rescue
    end
    begin
      Role.create(name: 'superadmin_role', system: true)
    rescue
    end
  end
end
