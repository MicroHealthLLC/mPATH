class ChangeColumnServiceName < ActiveRecord::Migration[5.2]
  def change
    remove_column(:active_storage_blobs, :service_name) rescue nil
  end

end
