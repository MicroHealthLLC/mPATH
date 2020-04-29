class Downloads::DataController < AuthenticatedController
  def facility_groups
    collection = FacilityGroup.all
    respond_to do |format|
      format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
    end
  end

  def statuses
    collection = Status.all
    respond_to do |format|
      format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
    end
  end

  def task_types
    collection = TaskType.all
    respond_to do |format|
      format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
    end
  end
end
