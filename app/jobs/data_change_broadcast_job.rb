class DataChangeBroadcastJob < ApplicationJob
  queue_as :data_change

  def perform(data = {})
    serialized_message = {}
    if data[:resource_type] == "Task"
      serialized_message = Task.find(data[:resource_id]).to_json
    elsif data[:resource_type] == "Issue"
      serialized_message = Issue.find(data[:resource_id]).to_json
    elsif data[:resource_type] == "Risk"
      serialized_message = Risk.find(data[:resource_id]).to_json
    elsif data[:resource_type] == "Lesson"
      serialized_message = Lesson.find(data[:resource_id]).to_json
    end
    ActionCable.server.broadcast("data_change_channel", {type: 'broadcast_change', data: serialized_message})
  end
end
