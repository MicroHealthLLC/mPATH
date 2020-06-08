ActiveAdmin.register Status do
  menu priority: 7
  actions :all, except: [:show]

  permit_params do
    permitted = [:name, :color]
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

