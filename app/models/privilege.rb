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

  # before_save :modify_values


  def modify_values
    att = self.attributes.dup
    att.each do |field, value|
      next if !value.is_a?(String)
      if value.include?("\n") || value.include?("]")
        att[field] = YAML.load(value).join("")
      end
    end
    self.attributes = att
  end

end
