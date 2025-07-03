ActiveAdmin.register ContractProjectDatum do
  menu parent: "Contracts", priority: 1
  permit_params :charge_code, :name, :contract_customer_id, :contract_award_to_id, :contract_type_id,
                :prime_or_sub, :contract_start_date, :contract_end_date, :total_contract_value,
                :contract_pop_id, :contract_current_pop_id, :contract_current_pop_start_date,
                :contract_current_pop_end_date, :total_founded_value, :billings_to_date, :comments,
                :contract_naic_id, :contract_vehicle_id, :contract_award_type_id, :user_id, :number,
                :co_contract_poc_id, :gov_contract_poc_id, :pm_contract_poc_id, :contract_number_id,
                :notes, :ignore_expired

  index do
    selectable_column
    id_column
    column :name
    column :charge_code
    column :contract_customer
    column :contract_award_to
    column :contract_type
    column :prime_or_sub
    column :contract_start_date
    column :contract_end_date
    column :total_contract_value
    column :contract_vehicle
    column :ignore_expired
    actions
  end

  filter :name
  filter :charge_code
  filter :contract_customer
  filter :contract_award_to
  filter :contract_type
  filter :contract_vehicle
  filter :contract_start_date
  filter :contract_end_date
  filter :ignore_expired

 form do |f|
    f.semantic_errors

    f.inputs "Contract Project Datum Details" do
      f.input :charge_code
      f.input :name

      f.input :contract_customer, as: :select, collection: ContractCustomer.all.pluck(:name, :id)
      f.input :contract_award_to, as: :select, collection: ContractAwardTo.all.pluck(:name, :id)
      f.input :contract_type, as: :select, collection: ContractType.all.pluck(:name, :id)
      f.input :prime_or_sub, as: :select, collection: ["Prime", "Sub"]

      f.input :contract_start_date, as: :datepicker
      f.input :contract_end_date, as: :datepicker
      f.input :total_contract_value

      f.input :contract_pop, as: :select, collection: ContractPop.all.pluck(:name, :id)
      f.input :contract_current_pop, as: :select, collection: ContractPop.all.pluck(:name, :id)
      f.input :contract_current_pop_start_date, as: :datepicker
      f.input :contract_current_pop_end_date, as: :datepicker

      f.input :total_founded_value
      f.input :billings_to_date
      f.input :comments

      f.input :contract_naic, as: :select, collection: ContractNaic.all.pluck(:name, :id)
      f.input :contract_vehicle, as: :select, collection: ContractVehicle.all.pluck(:name, :id)
      f.input :contract_award_type, as: :select, collection: ContractAwardType.all.pluck(:name, :id)

      f.input :user, as: :select, collection: User.all.pluck(:email, :id)
      f.input :number

      f.input :co_contract_poc_id, as: :select, collection: ContractProjectPoc.all.pluck(:name, :id)
      f.input :gov_contract_poc_id, as: :select, collection: ContractProjectPoc.all.pluck(:name, :id)
      f.input :pm_contract_poc_id, as: :select, collection: ContractProjectPoc.all.pluck(:name, :id)

    #   f.input :contract_number, as: :select, collection: ContractNumber.all.pluck(:number, :id)

      f.input :notes
      f.input :ignore_expired
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :charge_code
      row :contract_customer
      row :contract_award_to
      row :contract_type
      row :prime_or_sub
      row :contract_start_date
      row :contract_end_date
      row :total_contract_value
      row :total_founded_value
      row :billings_to_date
      row :contract_current_pop
      row :contract_current_pop_start_date
      row :contract_current_pop_end_date
      row :contract_vehicle
      row :user
      row :number
      row :co_contract_poc_id
      row :gov_contract_poc_id
      row :pm_contract_poc_id
      row :contract_number
      row :comments
      row :notes
      row :ignore_expired
      row :created_at
      row :updated_at
    end
  end
end
