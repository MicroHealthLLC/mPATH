ActiveAdmin.register LessonDetail do
  menu parent: "Lessons", priority: 3
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :finding, 
      :recommendation, 
      :user_id, 
      :lesson_id,  
      :detail_type
    ]
  end
  index do
    column :id
    column :finding
    column :recommendation
    column :lesson
    column :detail_type
  end
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Basic Details' do
      f.input :id, input_html: { value: f.object.id }, as: :hidden
      f.input :finding
      f.input :recommendation
      f.input :lesson, include_blank: false
      f.input :detail_type, as: :select, collection: [["Success","success"], ["Failure", "failure"], ["Best Practices", "best_practices"]], include_blank: false
    end
    f.actions
  end

end