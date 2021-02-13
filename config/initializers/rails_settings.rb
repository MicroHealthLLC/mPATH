# As system already have table setting, this patch will allow RailsSetting to use different table

module RailsSettings
  class SettingObject < ActiveRecord::Base
    self.table_name = 'rails_settings'
  end
end