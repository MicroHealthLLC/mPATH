module ActiveAdmin::UsersViewHelper

  def facility_privileges_options(fp, m_name)
    [ 
      ["Read", "R", {checked: fp.send(m_name).include?("R") ,onchange: "updateFacilityPrivileges(this)", name: "", "data-module-name" => m_name }], 
      ["Write", "W", {checked: fp.send(m_name).include?("W") , onchange: "updateFacilityPrivileges(this)", name: "", "data-module-name" => m_name }], 
      ["Delete", "D", {checked: fp.send(m_name).include?("D") , onchange: "updateFacilityPrivileges(this)", name: "", "data-module-name" => m_name }]
    ]
  end
end