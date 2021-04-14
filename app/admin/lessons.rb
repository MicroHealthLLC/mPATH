# ActiveAdmin.register Lesson do
#   # menu priority: 9
#   # actions :all, except: [:show]

#   # breadcrumb do
#   #   links = [link_to('Admin', admin_root_path), link_to('Projects', admin_facilities_path)]
#   #   if %(show edit).include?(params['action'])
#   #     links << link_to(facility.facility_name, edit_admin_facility_path)
#   #   end
#   #   links
#   # end

#   # permit_params do
#   #   permitted = [
#   #     :facility_name,
#   #     :address,
#   #     :point_of_contact,
#   #     :phone_number,
#   #     :country_code,
#   #     :email,
#   #     :facility_group_id,
#   #     :creator_id,
#   #     :status,
#   #     :lat,
#   #     :lng,
#   #     :status,
#   #     project_ids: [],
#   #     comments_attributes: [
#   #       :id,
#   #       :namespace,
#   #       :author_id,
#   #       :author_type,
#   #       :body,
#   #       :_destroy
#   #     ]
#   #   ]
#   # end

#   index title: 'Lessons' do
#     column :title
#     column :description
#     column :date
#     column :stage
#     column :task_type_id
#     actions defaults: false do |facility|
#       item "Edit", edit_admin_lesson_path(lesson), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
#       item "Delete", admin_lesson_path(lesson), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
#     end
#   end

# end
