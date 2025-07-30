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

ActiveRecord::Schema[8.0].define(version: 2025_07_30_115825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "component_selections", force: :cascade do |t|
    t.bigint "configuration_id", null: false
    t.string "component_type", null: false
    t.string "component_id", null: false
    t.string "component_name"
    t.jsonb "specifications", default: {}
    t.jsonb "options", default: {}
    t.decimal "price", precision: 10, scale: 2
    t.string "currency", default: "USD"
    t.integer "quantity", default: 1
    t.text "notes"
    t.string "status", default: "selected"
    t.datetime "selected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_component_selections_on_component_id"
    t.index ["component_type"], name: "index_component_selections_on_component_type"
    t.index ["configuration_id"], name: "index_component_selections_on_configuration_id"
    t.index ["options"], name: "index_component_selections_on_options", using: :gin
    t.index ["specifications"], name: "index_component_selections_on_specifications", using: :gin
    t.index ["status"], name: "index_component_selections_on_status"
  end

  create_table "configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "status", default: "draft"
    t.jsonb "system_specifications", default: {}
    t.jsonb "selected_components", default: {}
    t.jsonb "optimization_results", default: {}
    t.jsonb "wizard_progress", default: {}
    t.integer "current_step", default: 1
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.string "export_format"
    t.text "export_data"
    t.datetime "exported_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price"
    t.index ["completed"], name: "index_configurations_on_completed"
    t.index ["current_step"], name: "index_configurations_on_current_step"
    t.index ["optimization_results"], name: "index_configurations_on_optimization_results", using: :gin
    t.index ["selected_components"], name: "index_configurations_on_selected_components", using: :gin
    t.index ["status"], name: "index_configurations_on_status"
    t.index ["system_specifications"], name: "index_configurations_on_system_specifications", using: :gin
    t.index ["user_id"], name: "index_configurations_on_user_id"
    t.index ["wizard_progress"], name: "index_configurations_on_wizard_progress", using: :gin
  end

  create_table "users", force: :cascade do |t|
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
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "phone"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wizard_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "configuration_id"
    t.string "session_id", null: false
    t.integer "current_step", default: 1
    t.jsonb "step_data", default: {}
    t.jsonb "validation_errors", default: {}
    t.datetime "started_at"
    t.datetime "last_activity_at"
    t.datetime "completed_at"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["configuration_id"], name: "index_wizard_sessions_on_configuration_id"
    t.index ["current_step"], name: "index_wizard_sessions_on_current_step"
    t.index ["session_id"], name: "index_wizard_sessions_on_session_id", unique: true
    t.index ["status"], name: "index_wizard_sessions_on_status"
    t.index ["step_data"], name: "index_wizard_sessions_on_step_data", using: :gin
    t.index ["user_id"], name: "index_wizard_sessions_on_user_id"
    t.index ["validation_errors"], name: "index_wizard_sessions_on_validation_errors", using: :gin
  end

  add_foreign_key "component_selections", "configurations"
  add_foreign_key "configurations", "users"
  add_foreign_key "wizard_sessions", "configurations"
  add_foreign_key "wizard_sessions", "users"
end
