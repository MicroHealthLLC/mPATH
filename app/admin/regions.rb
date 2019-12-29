ActiveAdmin.register Region do

  # permit_params :name, :position, :boundary, :color

  permit_params do
    permitted = [:name, :position, :boundary, :color]
    # permitted << :other if params[:action] == 'create' && current_admin_user.present?
    permitted
  end
  
end
