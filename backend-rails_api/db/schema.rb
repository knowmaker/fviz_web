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

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gk", primary_key: "id_gk", id: :serial, force: :cascade do |t|
    t.integer "g_indicate", limit: 2, null: false
    t.integer "k_indicate", limit: 2, null: false
    t.string "color", limit: 50, null: false
  end

  create_table "gk_translations", primary_key: "id_gk_transl", id: :serial, force: :cascade do |t|
    t.string "gk_name", limit: 100, null: false
    t.string "locale", limit: 2, null: false
    t.integer "id_gk", null: false
    t.index ["id_gk", "locale"], name: "index_gk_translations_on_id_gk_and_locale", unique: true
    t.index ["locale"], name: "index_gk_translations_on_locale"
  end

  create_table "law_types", primary_key: "id_type", id: :serial, force: :cascade do |t|
    t.string "color", limit: 50, null: false
  end

  create_table "law_types_translations", primary_key: "id_type_transl", id: :serial, force: :cascade do |t|
    t.string "type_name", limit: 100, null: false
    t.string "locale", limit: 2, null: false
    t.integer "id_type", null: false
    t.index ["id_type", "locale"], name: "index_law_types_translations_on_id_type_and_locale", unique: true
    t.index ["locale"], name: "index_law_types_translations_on_locale"
  end

  create_table "laws", primary_key: "id_law", id: :serial, force: :cascade do |t|
    t.string "law_name"
    t.integer "first_element", null: false
    t.integer "second_element", null: false
    t.integer "third_element", null: false
    t.integer "fourth_element", null: false
    t.integer "id_user", null: false
    t.integer "id_type"
    t.integer "combination", array: true
    t.index ["combination", "id_user"], name: "unique_combination_user", unique: true
  end

  create_table "lt", primary_key: "id_lt", id: :serial, force: :cascade do |t|
    t.integer "l_indicate", limit: 2, null: false
    t.integer "t_indicate", limit: 2, null: false
  end

  create_table "quantity", primary_key: "id_value", id: :serial, force: :cascade do |t|
    t.string "symbol", limit: 100
    t.integer "m_indicate_auto", limit: 2, null: false
    t.integer "l_indicate_auto", limit: 2, null: false
    t.integer "t_indicate_auto", limit: 2, null: false
    t.integer "i_indicate_auto", limit: 2, null: false
    t.integer "id_lt", null: false
    t.integer "id_gk", null: false
    t.index ["id_lt", "id_gk"], name: "idx_unique_id_lt_id_gk", unique: true
  end

  create_table "quantity_translations", primary_key: "id_value_transl", id: :serial, force: :cascade do |t|
    t.string "value_name", limit: 200
    t.string "unit", limit: 100
    t.string "locale", limit: 2, null: false
    t.integer "id_value", null: false
    t.index ["id_value", "locale"], name: "index_quantity_translations_on_id_value_and_locale", unique: true
    t.index ["locale"], name: "index_quantity_translations_on_locale"
  end

  create_table "represents", primary_key: "id_repr", id: :serial, force: :cascade do |t|
    t.string "title", limit: 100
    t.integer "id_user", null: false
    t.integer "active_quantities", null: false, array: true
  end

  create_table "users", primary_key: "id_user", id: :serial, force: :cascade do |t|
    t.string "email", limit: 100, null: false
    t.string "password", null: false
    t.string "last_name", limit: 100
    t.string "first_name", limit: 100
    t.string "patronymic", limit: 100
    t.boolean "role", default: false, null: false
    t.string "confirmation_token"
    t.boolean "confirmed", default: false
    t.integer "active_repr"
    t.string "locale", limit: 2, default: "ru"
    t.index ["email"], name: "unique_email", unique: true
  end

  add_foreign_key "gk_translations", "gk", column: "id_gk", primary_key: "id_gk", name: "gk_translations_id_gk_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "law_types_translations", "law_types", column: "id_type", primary_key: "id_type", name: "law_types_translations_id_type_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laws", "law_types", column: "id_type", primary_key: "id_type", name: "laws_id_type_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "laws", "quantity", column: "first_element", primary_key: "id_value", name: "laws_first_element_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laws", "quantity", column: "fourth_element", primary_key: "id_value", name: "laws_fourth_element_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laws", "quantity", column: "second_element", primary_key: "id_value", name: "laws_second_element_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laws", "quantity", column: "third_element", primary_key: "id_value", name: "laws_third_element_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laws", "users", column: "id_user", primary_key: "id_user", name: "laws_id_user_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "quantity", "gk", column: "id_gk", primary_key: "id_gk", name: "level", on_update: :cascade, on_delete: :cascade
  add_foreign_key "quantity", "lt", column: "id_lt", primary_key: "id_lt", name: "cell", on_update: :cascade, on_delete: :cascade
  add_foreign_key "quantity_translations", "quantity", column: "id_value", primary_key: "id_value", name: "quantity_translations_id_value_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "represents", "users", column: "id_user", primary_key: "id_user", name: "represents_id_user_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "represents", column: "active_repr", primary_key: "id_repr", name: "fk_active_repr", on_update: :cascade, on_delete: :nullify
end
