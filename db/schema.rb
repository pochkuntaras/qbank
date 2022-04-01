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

ActiveRecord::Schema[7.0].define(version: 2022_04_01_145708) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "organization_name", null: false
    t.string "iban", limit: 34, null: false
    t.string "bic", limit: 11, null: false
    t.integer "balance_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bic"], name: "index_bank_accounts_on_bic", unique: true
    t.index ["iban"], name: "index_bank_accounts_on_iban", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "bank_account_id", null: false
    t.string "counterparty_name", null: false
    t.string "counterparty_iban", limit: 34, null: false
    t.string "counterparty_bic", limit: 11, null: false
    t.string "amount_currency", limit: 3, default: "EUR", null: false
    t.string "description", null: false
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  end

  add_foreign_key "transactions", "bank_accounts"
end
