class ChangeTimesheetTableName < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :timesheets, :efforts
  end

  def self.down
    rename_table :efforts, :timesheets
  end
end
