ActiveAdmin.register IssueType do

  menu priority: 11
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

  controller do
    def index
      super do |format|
        format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
      end
    end
  end

end
