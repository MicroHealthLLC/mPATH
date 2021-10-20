class DataChangeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "data_change_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    p_data = {resource_id: data['id'], resource_type: data['resource_type']}
    DataChangeBroadcastJob.perform_later(p_data)
  end

end
