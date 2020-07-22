ActiveAdmin.register_page "Settings" do
  menu false

  content title: "App configurations" do
    div id: "settings_container"
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
  end
end
