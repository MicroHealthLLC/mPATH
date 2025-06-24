ActiveAdmin.register ContractAwardType do
  menu parent: "Contracts", priority: 1
  permit_params :name, :user_id

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :user
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "Contract Award Type Details" do
      f.input :name
      f.input :user, as: :select, collection: User.all.pluck(:email, :id), prompt: "Select a user"
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :user
      row :created_at
      row :updated_at
    end
  end
end
