class AddFieldsToActivestorageBlob < ActiveRecord::Migration[7.0]
  def change
    add_column :active_storage_blobs, :record_id, :integer,null: false
    add_column :active_storage_blobs, :record_type, :string, null: false
    add_column :active_storage_blobs, :name, :string
  end
end
