MIGRATION_BASE_CLASS = if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration[5.0]
else
  ActiveRecord::Migration
end

class RailsSettingsMigration < MIGRATION_BASE_CLASS
  def self.up
    create_table :rails_settings do |t|
      t.string     :var,    :null => false
      t.text       :value
      t.references :target, :null => false, :polymorphic => true
      t.timestamps :null => true
    end
    add_index :rails_settings, [ :target_type, :target_id, :var ], :unique => true
  end

  def self.down
    drop_table :rails_settings
  end
end
