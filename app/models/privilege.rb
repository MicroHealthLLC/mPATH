class Privilege < ApplicationRecord
  belongs_to :user

  # serialize :overview, Array
  # serialize :tasks, Array
  # serialize :notes, Array
  # serialize :issues, Array
  # serialize :admin, Array
  # serialize :watch_view, Array
  # serialize :documents, Array
  # serialize :facility_manager_view, Array
  # serialize :risks, Array
  # serialize :lessons, Array
  # serialize :sheets_view, Array
  # serialize :map_view, Array
  # serialize :gantt_view, Array
  # serialize :kanban_view, Array
  # serialize :calendar_view, Array
  # serialize :members, Array


  # NOTE: sequence matters, because we parameters are sending an array and 
  # we are saving it as string.
  before_save :modify_values
  # before_save :assign_default_privilege
  validate :check_minimum_privilege

  def check_minimum_privilege
    fp = self
    modify_values
    if !fp.sheets_view.present? && !fp.map_view.present? && !fp.gantt_view.present? && !fp.kanban_view.present? && !fp.calendar_view.present? && !fp.members.present?
      fp.errors.add(" ", "Please select at least one navigation view in advanced tab.")
    end
  end
  #NOTE: As per new privilege setting we are just checking few settings only.
  def assign_default_privilege
    if !self.sheets_view.include?("R") && !self.map_view.include?("R") && !self.gantt_view.include?("R") && !self.kanban_view.include?("R") && !self.calendar_view.include?("R") && !self.members.include?("R") 
      self.sheets_view = (self.sheets_view.chars + ["R"]).join("")
    end
  end

  def modify_values
    att = self.attributes.dup
    att.each do |field, value|
      next if !value.is_a?(String)
      if value.include?("\n") || value.include?("]")
        att[field] = YAML.load(value).join("")
      end
    end
    if self.admin_was.include?("R") && !self.admin.include?("R")
      att["admin"] = ""
    elsif att["admin"] && !att["admin"].chars.include?("R") && (att["admin"].chars.include?("W") || att["admin"].chars.include?("D") )
      att["admin"] = att["admin"] + "R"
    end    

    self.attributes = att
  end

end
