module ActiveAdmin::UsersViewHelper

  def facility_privileges_options(fp, user_privileges, m_name)

    rchecked = fp.new_record? ? user_privileges.send(m_name)&.include?("R") : fp.send(m_name)&.include?("R")
    wchecked = fp.new_record? ? user_privileges.send(m_name)&.include?("W") : fp.send(m_name)&.include?("W")
    dchecked = fp.new_record? ? user_privileges.send(m_name)&.include?("D") : fp.send(m_name)&.include?("D")

    [ 
      ["Read", "R", {checked: rchecked, "data-module-name" => m_name }], 
      ["Write", "W", {checked: wchecked,  "data-module-name" => m_name }], 
      ["Destroy", "D", {checked: dchecked, "data-module-name" => m_name }]
    ]
  end
  
  def project_privileges_options(user_privileges, m_name)

    rchecked = user_privileges.send(m_name)&.include?("R")
    wchecked = user_privileges.send(m_name)&.include?("W")
    dchecked = user_privileges.send(m_name)&.include?("D")

    [ 
      ["Read", "R", {checked: rchecked, "data-module-name" => m_name }], 
      ["Write", "W", {checked: wchecked,  "data-module-name" => m_name }], 
      ["Destroy", "D", {checked: dchecked, "data-module-name" => m_name }]
    ]
  end


  def top_navigation_privileges_options(user_privileges, m_name)
    rchecked = user_privileges.send(m_name)&.include?("R")
    [ 
      ["Read", "R", {checked: rchecked, "data-module-name" => m_name }]
    ]
  end

  def admin_privileges_options(user_privileges, m_name)

    rchecked = user_privileges.send(m_name)&.include?("R")
    wchecked = user_privileges.send(m_name)&.include?("W")
    dchecked = user_privileges.send(m_name)&.include?("D")

    [ 
      ["Read", "R", {checked: rchecked, "data-module-name" => m_name }], 
      ["Write", "W", {checked: wchecked,  "data-module-name" => m_name }], 
      ["Destroy", "D", {checked: dchecked, "data-module-name" => m_name }]
    ]
  end

end