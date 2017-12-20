# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171219111633) do

  create_table "MESSAGECOUNTER", primary_key: "ID", id: :integer, force: :cascade do |t|
    t.varchar "FILEMASK", limit: 50
    t.date "FILEDATE"
    t.integer "SERIALNUMBER"
    t.index ["FILEMASK", "FILEDATE"], name: "IDX_DATE_MASK", unique: true
  end

  create_table "TACTIONS", primary_key: "ID", id: :integer, force: :cascade do |t|
    t.integer "TFILE_ID", null: false
    t.varchar "ACTION", limit: 100, null: false
    t.datetime "DATE"
    t.varchar "PATHIN", limit: 200, null: false
    t.varchar "PATHOUT", limit: 200
  end

  create_table "TFILES", primary_key: "ID", id: :integer, force: :cascade do |t|
    t.varchar "NAME", limit: 250, null: false
    t.date "DATE", null: false
    t.integer "VERSION", default: 0
    t.time "TIME", precision: 7
    t.boolean "SUCCESS", default: false
    t.index ["NAME", "DATE", "VERSION"], name: "IDX_DATE_MASK", unique: true
  end

  create_table "TRELATIONS", primary_key: "ID", id: :integer, force: :cascade do |t|
    t.integer "TFILE_ID", null: false
    t.integer "TFILE_ID_PARENT", null: false
    t.varchar "TYPE", limit: 20
    t.index ["TFILE_ID", "TFILE_ID_PARENT", "TYPE"], name: "IDX_FILE_PARENT_TYPE", unique: true
  end

  create_table "TXML_DATA", primary_key: "ID", id: :integer, force: :cascade do |t|
    t.integer "TFILE_ID", null: false
    t.string "TYPE", limit: 100, null: false
    t.string "NAME", limit: 100, null: false
    t.text "VALUE"
    t.integer "TXML_DATA_ID"
  end

  create_table "sysdiagrams", primary_key: "diagram_id", id: :integer, force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.integer "principal_id", null: false
    t.integer "version"
    t.binary "definition"
    t.index ["principal_id", "name"], name: "UK_principal_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "role", default: -1, null: false
    t.string "login", default: "", null: false
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "email", unique: true
    t.index ["login"], name: "login", unique: true
    t.index ["reset_password_token"], name: "reset_password_token", unique: true
    t.index ["unlock_token"], name: "unlock_token", unique: true
  end

  add_foreign_key "TACTIONS", "TFILES", column: "TFILE_ID", primary_key: "ID", name: "FK_TACTIONS_TFILES"
  add_foreign_key "TRELATIONS", "TFILES", column: "TFILE_ID", primary_key: "ID", name: "FK_TRELATIONS_TFILES"
end
