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

ActiveRecord::Schema.define(version: 2019_10_31_221549) do

  create_table "stocks", force: :cascade do |t|
    t.integer "share_counts"
    t.string "company_code"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_code"], name: "index_stocks_on_company_code"
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "aasm_state"
    t.decimal "amount"
    t.string "tx_no"
    t.integer "to_wallet_id"
    t.integer "from_wallet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aasm_state"], name: "index_transactions_on_aasm_state"
    t.index ["from_wallet_id"], name: "index_transactions_on_from_wallet_id"
    t.index ["to_wallet_id"], name: "index_transactions_on_to_wallet_id"
    t.index ["tx_no"], name: "index_transactions_on_tx_no", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
  end

  create_table "wallets", force: :cascade do |t|
    t.decimal "cash_deposit"
    t.decimal "locked"
    t.string "walletable_type"
    t.integer "walletable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["walletable_type", "walletable_id"], name: "index_wallets_on_walletable_type_and_walletable_id"
  end

end
