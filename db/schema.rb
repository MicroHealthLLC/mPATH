# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_02_210024) do

  create_table "active_admin_comments", charset: "utf8", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_id"], name: "index_active_storage_attachments_on_record_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "checklists", charset: "utf8", force: :cascade do |t|
    t.string "listable_type"
    t.integer "listable_id"
    t.boolean "checked"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "position", default: 0
    t.date "due_date"
    t.index ["listable_id"], name: "index_checklists_on_listable_id"
    t.index ["listable_type"], name: "index_checklists_on_listable_type"
    t.index ["position"], name: "index_checklists_on_position"
    t.index ["user_id"], name: "index_checklists_on_user_id"
  end

  create_table "contract_agencies", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_award_tos", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_award_types", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_categories", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_classifications", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_client_types", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_current_pops", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_customers", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_naics", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_numbers", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_pocs", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_pops", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_primes", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_privileges", charset: "utf8", force: :cascade do |t|
    t.string "overview", default: "--- []\n"
    t.string "tasks", default: "--- []\n"
    t.string "notes", default: "--- []\n"
    t.string "issues", default: "--- []\n"
    t.string "admin", default: "--- []\n"
    t.string "risks", default: "--- []\n"
    t.integer "user_id"
    t.integer "project_id"
    t.string "contract_ids", default: "--- []\n"
    t.string "lessons", default: "--- []\n"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_project_data", charset: "utf8", force: :cascade do |t|
    t.string "charge_code"
    t.string "name"
    t.integer "contract_customer_id"
    t.integer "contract_award_to_id"
    t.integer "contract_type_id"
    t.string "prime_or_sub"
    t.datetime "contract_start_date"
    t.datetime "contract_end_date"
    t.decimal "total_contract_value", precision: 19, scale: 4, default: "0.0"
    t.integer "contract_pop_id"
    t.integer "contract_current_pop_id"
    t.datetime "contract_current_pop_start_date"
    t.datetime "contract_current_pop_end_date"
    t.decimal "total_founded_value", precision: 19, scale: 4, default: "0.0"
    t.decimal "billings_to_date", precision: 19, scale: 4, default: "0.0"
    t.string "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "contract_naic_id"
    t.integer "contract_vehicle_id"
    t.integer "contract_award_type_id"
    t.integer "user_id"
    t.string "number"
    t.integer "co_contract_poc_id"
    t.integer "gov_contract_poc_id"
    t.integer "pm_contract_poc_id"
    t.integer "contract_number_id"
    t.text "notes"
    t.boolean "ignore_expired", default: false
  end

  create_table "contract_project_pocs", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "poc_type"
    t.string "email"
    t.string "title"
    t.string "work_number"
    t.string "mobile_number"
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_statuses", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_sub_categories", charset: "utf8", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_types", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_vehicle_numbers", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_vehicle_types", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "contract_vehicles", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "contract_sub_category_id"
    t.integer "contract_agency_id"
    t.integer "contract_vehicle_type_id"
    t.integer "user_id"
    t.string "full_name"
    t.decimal "ceiling", precision: 19, scale: 4, default: "0.0"
    t.datetime "base_period_start"
    t.datetime "base_period_end"
    t.datetime "option_period_start"
    t.datetime "option_period_end"
    t.integer "contract_number_id"
    t.decimal "caf_fees", precision: 4, scale: 2, default: "0.0"
  end

  create_table "contracts", charset: "utf8", force: :cascade do |t|
    t.bigint "contract_type_id", null: false
    t.integer "project_code"
    t.string "nickname"
    t.bigint "contract_status_id"
    t.bigint "contract_customer_id"
    t.bigint "contract_vehicle_id"
    t.bigint "contract_vehicle_number_id"
    t.bigint "contract_number_id"
    t.bigint "contract_classification_id"
    t.bigint "subcontract_number_id"
    t.bigint "contract_prime_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "contract_current_pop_id"
    t.datetime "current_pop_start_time"
    t.datetime "current_pop_end_time"
    t.integer "days_remaining"
    t.float "total_contract_value"
    t.float "current_pop_value"
    t.float "current_pop_funded"
    t.float "total_contract_funded"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "facility_group_id"
    t.bigint "project_id"
    t.string "name"
    t.integer "total_subcontracts", default: 0
    t.integer "contract_category_id"
    t.integer "contract_client_type_id"
    t.text "remarks"
    t.index ["facility_group_id"], name: "index_contracts_on_facility_group_id"
    t.index ["project_id"], name: "index_contracts_on_project_id"
  end

  create_table "facilities", charset: "utf8", force: :cascade do |t|
    t.string "facility_name", default: "", null: false
    t.integer "region_name", default: 0, null: false
    t.string "address"
    t.string "point_of_contact"
    t.string "phone_number"
    t.string "email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "facility_group_id"
    t.bigint "creator_id"
    t.string "lat"
    t.string "lng"
    t.integer "status", default: 1
    t.string "country_code", default: ""
    t.integer "project_facility_group_id"
    t.boolean "is_portfolio", default: true
    t.integer "project_id"
    t.index ["creator_id"], name: "index_facilities_on_creator_id"
    t.index ["facility_group_id"], name: "index_facilities_on_facility_group_id"
    t.index ["is_portfolio"], name: "index_facilities_on_is_portfolio"
    t.index ["project_id"], name: "index_facilities_on_project_id"
    t.index ["status"], name: "index_facilities_on_status"
  end

  create_table "facility_groups", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.integer "status", default: 1
    t.integer "region_type", default: 0
    t.string "center"
    t.bigint "project_id"
    t.integer "progress", default: 0
    t.boolean "is_portfolio", default: false
    t.integer "user_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["project_id"], name: "index_facility_groups_on_project_id"
  end

  create_table "facility_privileges", charset: "utf8", force: :cascade do |t|
    t.string "overview", default: "---\n- R\n"
    t.string "tasks", default: "---\n- R\n"
    t.string "notes", default: "---\n- R\n"
    t.string "issues", default: "---\n- R\n"
    t.string "admin", default: "---\n- R\n"
    t.string "risks", default: "---\n- R\n"
    t.integer "user_id"
    t.integer "facility_project_id"
    t.integer "facility_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lessons", default: "---\n- R\n"
    t.integer "project_id"
    t.integer "group_number", default: 0
    t.string "facility_project_ids", default: "--- []\n"
  end

  create_table "facility_projects", charset: "utf8", force: :cascade do |t|
    t.bigint "facility_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.bigint "status_id"
    t.integer "progress", default: 0
    t.string "color", default: "#ff0000"
    t.integer "facility_group_id"
    t.index ["facility_id"], name: "index_facility_projects_on_facility_id"
    t.index ["project_id"], name: "index_facility_projects_on_project_id"
    t.index ["status_id"], name: "index_facility_projects_on_status_id"
  end

  create_table "favorite_filters", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "is_default", default: false
    t.boolean "shared"
    t.boolean "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_severities", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_stages", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "percentage", default: 0
  end

  create_table "issue_types", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_users", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", default: "responsible"
    t.index ["issue_id"], name: "index_issue_users_on_issue_id"
    t.index ["user_id"], name: "index_issue_users_on_user_id"
    t.index ["user_type"], name: "index_issue_users_on_user_type"
  end

  create_table "issues", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "description", size: :long
    t.bigint "issue_type_id"
    t.bigint "issue_severity_id"
    t.bigint "facility_project_id"
    t.date "start_date"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "progress", default: 0
    t.boolean "auto_calculate", default: true
    t.boolean "watched", default: false
    t.datetime "watched_at"
    t.bigint "issue_stage_id"
    t.integer "kanban_order", default: 0
    t.integer "task_type_id"
    t.boolean "important", default: false
    t.boolean "draft", default: false
    t.boolean "on_hold", default: false
    t.boolean "reportable", default: false
    t.integer "contract_id"
    t.integer "project_contract_id"
    t.integer "project_contract_vehicle_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["facility_project_id"], name: "index_issues_on_facility_project_id"
    t.index ["issue_severity_id"], name: "index_issues_on_issue_severity_id"
    t.index ["issue_stage_id"], name: "index_issues_on_issue_stage_id"
    t.index ["issue_type_id"], name: "index_issues_on_issue_type_id"
    t.index ["task_type_id"], name: "index_issues_on_task_type_id"
  end

  create_table "lesson_details", charset: "utf8", force: :cascade do |t|
    t.text "finding"
    t.text "recommendation"
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "detail_type", default: "success"
  end

  create_table "lesson_stages", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lesson_users", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_type", default: "responsible"
    t.index ["lesson_id"], name: "index_lesson_users_on_lesson_id"
    t.index ["user_id"], name: "index_lesson_users_on_user_id"
  end

  create_table "lessons", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "date"
    t.string "stage"
    t.integer "task_type_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lesson_stage_id"
    t.boolean "important", default: false
    t.integer "facility_project_id"
    t.boolean "reportable", default: false
    t.boolean "draft", default: false
    t.integer "contract_id"
    t.integer "project_contract_id"
    t.integer "project_contract_vehicle_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["facility_project_id"], name: "index_lessons_on_facility_project_id"
    t.index ["lesson_stage_id"], name: "index_lessons_on_lesson_stage_id"
    t.index ["task_type_id"], name: "index_lessons_on_task_type_id"
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "notes", charset: "utf8", force: :cascade do |t|
    t.string "noteable_type"
    t.integer "noteable_id"
    t.bigint "user_id"
    t.text "body", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_notes_on_created_at"
    t.index ["noteable_id"], name: "index_notes_on_noteable_id"
    t.index ["noteable_type"], name: "index_notes_on_noteable_type"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "organizations", charset: "utf8", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privileges", charset: "utf8", force: :cascade do |t|
    t.string "overview"
    t.string "tasks"
    t.string "notes"
    t.string "issues"
    t.string "admin"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "map_view"
    t.string "gantt_view"
    t.string "watch_view"
    t.string "documents"
    t.string "members"
    t.string "facility_manager_view"
    t.string "sheets_view"
    t.string "kanban_view"
    t.string "risks"
    t.string "calendar_view"
    t.string "lessons"
    t.string "portfolio_view"
    t.string "settings_view", default: "R"
    t.string "contract_data"
    t.index ["user_id"], name: "index_privileges_on_user_id"
  end

  create_table "progress_lists", charset: "utf8", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "checklist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_progress_lists_on_checklist_id"
    t.index ["user_id"], name: "index_progress_lists_on_user_id"
  end

  create_table "project_contract_vehicles", charset: "utf8", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "contract_vehicle_id", null: false
    t.integer "user_id"
    t.integer "facility_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_contracts", charset: "utf8", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "contract_project_datum_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "facility_group_id"
  end

  create_table "project_facility_groups", charset: "utf8", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "facility_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_default", default: false
  end

  create_table "project_issue_severities", charset: "utf8", force: :cascade do |t|
    t.bigint "issue_severity_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_severity_id"], name: "index_project_issue_severities_on_issue_severity_id"
    t.index ["project_id"], name: "index_project_issue_severities_on_project_id"
  end

  create_table "project_issue_stages", charset: "utf8", force: :cascade do |t|
    t.integer "project_id"
    t.integer "issue_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_stage_id"], name: "index_project_issue_stages_on_issue_stage_id"
    t.index ["project_id"], name: "index_project_issue_stages_on_project_id"
  end

  create_table "project_issue_types", charset: "utf8", force: :cascade do |t|
    t.bigint "issue_type_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_type_id"], name: "index_project_issue_types_on_issue_type_id"
    t.index ["project_id"], name: "index_project_issue_types_on_project_id"
  end

  create_table "project_lesson_stages", charset: "utf8", force: :cascade do |t|
    t.integer "project_id"
    t.integer "lesson_stage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_privileges", charset: "utf8", force: :cascade do |t|
    t.string "overview", default: "---\n- R\n"
    t.string "tasks", default: "---\n- R\n"
    t.string "notes", default: "---\n- R\n"
    t.string "issues", default: "---\n- R\n"
    t.string "admin"
    t.string "risks", default: "---\n- R\n"
    t.string "lessons", default: "---\n- R\n"
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "project_ids", default: "--- []\n"
    t.string "contracts"
    t.string "cn_overview", default: "--- []\n"
    t.string "cn_tasks", default: "--- []\n"
    t.string "cn_notes", default: "--- []\n"
    t.string "cn_issues", default: "--- []\n"
    t.string "cn_risks", default: "--- []\n"
    t.string "cn_lessons", default: "--- []\n"
    t.string "admin_groups", default: "--- []\n"
    t.string "admin_contracts", default: "--- []\n"
    t.string "admin_facilities", default: "--- []\n"
  end

  create_table "project_risk_stages", charset: "utf8", force: :cascade do |t|
    t.integer "project_id"
    t.integer "risk_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_risk_stages_on_project_id"
    t.index ["risk_stage_id"], name: "index_project_risk_stages_on_risk_stage_id"
  end

  create_table "project_statuses", charset: "utf8", force: :cascade do |t|
    t.bigint "status_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_statuses_on_project_id"
    t.index ["status_id"], name: "index_project_statuses_on_status_id"
  end

  create_table "project_task_stages", charset: "utf8", force: :cascade do |t|
    t.integer "project_id"
    t.integer "task_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_task_stages_on_project_id"
    t.index ["task_stage_id"], name: "index_project_task_stages_on_task_stage_id"
  end

  create_table "project_task_types", charset: "utf8", force: :cascade do |t|
    t.bigint "task_type_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_task_types_on_project_id"
    t.index ["task_type_id"], name: "index_project_task_types_on_task_type_id"
  end

  create_table "project_types", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_project_types_on_id"
  end

  create_table "project_users", charset: "utf8", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.bigint "project_type_id"
    t.integer "status", default: 1
    t.integer "progress", default: 0
    t.index ["project_type_id"], name: "index_projects_on_project_type_id"
    t.index ["uuid"], name: "index_projects_on_uuid", unique: true
  end

  create_table "query_filters", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "filter_key"
    t.text "filter_value"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "favorite_filter_id"
    t.index ["user_id"], name: "index_query_filters_on_user_id"
  end

  create_table "rails_settings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_rails_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_rails_settings_on_target_type_and_target_id"
  end

  create_table "region_states", charset: "utf8", force: :cascade do |t|
    t.bigint "facility_group_id"
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_group_id"], name: "index_region_states_on_facility_group_id"
    t.index ["state_id"], name: "index_region_states_on_state_id"
  end

  create_table "related_issues", charset: "utf8", force: :cascade do |t|
    t.string "relatable_type"
    t.integer "relatable_id"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_related_issues_on_issue_id"
    t.index ["relatable_id"], name: "index_related_issues_on_relatable_id"
    t.index ["relatable_type"], name: "index_related_issues_on_relatable_type"
  end

  create_table "related_risks", charset: "utf8", force: :cascade do |t|
    t.string "relatable_type"
    t.integer "relatable_id"
    t.bigint "risk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relatable_id"], name: "index_related_risks_on_relatable_id"
    t.index ["relatable_type"], name: "index_related_risks_on_relatable_type"
    t.index ["risk_id"], name: "index_related_risks_on_risk_id"
  end

  create_table "related_tasks", charset: "utf8", force: :cascade do |t|
    t.string "relatable_type"
    t.integer "relatable_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relatable_id"], name: "index_related_tasks_on_relatable_id"
    t.index ["relatable_type"], name: "index_related_tasks_on_relatable_type"
    t.index ["task_id"], name: "index_related_tasks_on_task_id"
  end

  create_table "risk_stages", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "percentage", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "risk_users", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "risk_id"
    t.string "timestamps"
    t.string "user_type", default: "responsible"
    t.index ["risk_id"], name: "index_risk_users_on_risk_id"
    t.index ["user_id"], name: "index_risk_users_on_user_id"
    t.index ["user_type"], name: "index_risk_users_on_user_type"
  end

  create_table "risks", charset: "utf8", force: :cascade do |t|
    t.text "risk_description"
    t.text "impact_description"
    t.date "start_date"
    t.date "due_date"
    t.boolean "auto_calculate", default: true
    t.integer "progress", default: 0
    t.integer "probability", default: 1
    t.integer "impact_level", default: 1
    t.integer "priority_level", default: 1
    t.integer "risk_approach", default: 0
    t.text "risk_approach_description"
    t.boolean "watched", default: false
    t.datetime "watched_at"
    t.bigint "user_id"
    t.bigint "facility_project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "task_type_id"
    t.string "text"
    t.integer "kanban_order", default: 0
    t.bigint "risk_stage_id"
    t.string "probability_name"
    t.string "impact_level_name"
    t.text "probability_description"
    t.string "approval_time"
    t.boolean "approved"
    t.boolean "important", default: false
    t.boolean "ongoing", default: false
    t.boolean "draft", default: false
    t.boolean "on_hold", default: false
    t.text "explanation"
    t.integer "duration"
    t.integer "status"
    t.string "duration_name"
    t.string "status_name"
    t.boolean "reportable", default: false
    t.date "closed_date"
    t.integer "contract_id"
    t.integer "project_contract_id"
    t.integer "project_contract_vehicle_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["due_date"], name: "index_risks_on_due_date"
    t.index ["facility_project_id"], name: "index_risks_on_facility_project_id"
    t.index ["risk_stage_id"], name: "index_risks_on_risk_stage_id"
    t.index ["task_type_id"], name: "index_risks_on_task_type_id"
    t.index ["user_id"], name: "index_risks_on_user_id"
  end

  create_table "role_privileges", charset: "utf8", force: :cascade do |t|
    t.integer "role_id", null: false
    t.string "name", null: false
    t.string "privilege"
    t.string "role_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id", "role_type"], name: "index_role_privileges_on_role_id_and_role_type"
  end

  create_table "role_users", charset: "utf8", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.integer "project_id"
    t.integer "facility_project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "project_contract_id"
    t.integer "project_contract_vehicle_id"
    t.string "resource_type"
    t.integer "resource_id"
    t.index ["facility_project_id", "project_contract_id"], name: "index_role_users_on_facility_project_id_and_project_contract_id"
    t.index ["role_id", "user_id", "project_id"], name: "index_role_users_on_role_id_and_user_id_and_project_id"
  end

  create_table "roles", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "is_portfolio", default: false
    t.boolean "is_default", default: false
    t.string "type_of"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "user_id", "is_default"], name: "index_roles_on_project_id_and_user_id_and_is_default"
  end

  create_table "settings", charset: "utf8", force: :cascade do |t|
    t.text "office365_key"
    t.text "office365_secret"
    t.text "google_map_key"
    t.text "google_oauth_key"
    t.text "google_oauth_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "passwords_key"
  end

  create_table "sorts", charset: "utf8", force: :cascade do |t|
    t.string "relation"
    t.string "column", default: "id"
    t.string "order", default: "asc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["column"], name: "index_sorts_on_column"
    t.index ["order"], name: "index_sorts_on_order"
    t.index ["relation"], name: "index_sorts_on_relation"
  end

  create_table "states", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "center", default: "[]"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "subcontract_numbers", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "task_stages", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "percentage", default: 0
  end

  create_table "task_types", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "progress", default: 0
  end

  create_table "task_users", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", default: "responsible"
    t.index ["task_id"], name: "index_task_users_on_task_id"
    t.index ["user_id"], name: "index_task_users_on_user_id"
    t.index ["user_type"], name: "index_task_users_on_user_type"
  end

  create_table "tasks", charset: "utf8", force: :cascade do |t|
    t.string "text"
    t.text "description", size: :long
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "progress", default: 0
    t.bigint "task_type_id"
    t.date "start_date"
    t.bigint "facility_project_id"
    t.boolean "auto_calculate", default: true
    t.boolean "watched", default: false
    t.datetime "watched_at"
    t.bigint "task_stage_id"
    t.integer "kanban_order", default: 0
    t.boolean "important", default: false
    t.boolean "ongoing", default: false
    t.boolean "draft", default: false
    t.boolean "on_hold", default: false
    t.boolean "reportable", default: false
    t.date "closed_date"
    t.integer "contract_id"
    t.integer "project_contract_id"
    t.integer "project_contract_vehicle_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["due_date"], name: "index_tasks_on_due_date"
    t.index ["facility_project_id"], name: "index_tasks_on_facility_project_id"
    t.index ["task_stage_id"], name: "index_tasks_on_task_stage_id"
    t.index ["task_type_id"], name: "index_tasks_on_task_type_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.string "phone_number"
    t.string "address"
    t.integer "role", default: 0
    t.string "provider"
    t.string "uid"
    t.string "login"
    t.integer "status", default: 1
    t.string "lat"
    t.string "lng"
    t.string "country_code", default: ""
    t.string "color"
    t.bigint "organization_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "checklists", "users"
  add_foreign_key "contracts", "facility_groups"
  add_foreign_key "contracts", "projects"
  add_foreign_key "facilities", "users", column: "creator_id"
  add_foreign_key "facility_groups", "projects"
  add_foreign_key "facility_projects", "facilities"
  add_foreign_key "facility_projects", "projects"
  add_foreign_key "facility_projects", "statuses"
  add_foreign_key "issue_users", "issues"
  add_foreign_key "issue_users", "users"
  add_foreign_key "issues", "facility_projects"
  add_foreign_key "issues", "issue_severities"
  add_foreign_key "issues", "issue_stages"
  add_foreign_key "issues", "issue_types"
  add_foreign_key "privileges", "users"
  add_foreign_key "project_issue_severities", "issue_severities"
  add_foreign_key "project_issue_severities", "projects"
  add_foreign_key "project_issue_types", "issue_types"
  add_foreign_key "project_issue_types", "projects"
  add_foreign_key "project_statuses", "projects"
  add_foreign_key "project_statuses", "statuses"
  add_foreign_key "project_task_types", "projects"
  add_foreign_key "project_task_types", "task_types"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "project_types"
  add_foreign_key "region_states", "facility_groups"
  add_foreign_key "region_states", "states"
  add_foreign_key "related_issues", "issues"
  add_foreign_key "related_risks", "risks"
  add_foreign_key "related_tasks", "tasks"
  add_foreign_key "risk_users", "risks"
  add_foreign_key "risk_users", "users"
  add_foreign_key "risks", "facility_projects"
  add_foreign_key "risks", "risk_stages"
  add_foreign_key "risks", "task_types"
  add_foreign_key "risks", "users"
  add_foreign_key "task_users", "tasks"
  add_foreign_key "task_users", "users"
  add_foreign_key "tasks", "facility_projects"
  add_foreign_key "tasks", "task_stages"
  add_foreign_key "tasks", "task_types"
  add_foreign_key "users", "organizations"
end
