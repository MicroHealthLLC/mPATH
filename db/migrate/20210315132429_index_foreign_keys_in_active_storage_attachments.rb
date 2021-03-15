class IndexForeignKeysInActiveStorageAttachments < ActiveRecord::Migration[5.2]
  def change
    add_index :active_storage_attachments, :record_id
  end
end
