# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180617232228) do

  create_table "plaid_rails_accounts", force: true do |t|
    t.string   "access_token"
    t.string   "token"
    t.string   "plaid_type"
    t.string   "name"
    t.string   "bank_name"
    t.integer  "number"
    t.string   "plaid_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "last_sync"
    t.decimal  "current_balance",         precision: 10, scale: 2
    t.decimal  "available_balance",       precision: 10, scale: 2
    t.string   "error"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "transactions_start_date"
    t.string   "item_id"
  end

  add_index "plaid_rails_accounts", ["access_token"], name: "index_plaid_rails_accounts_on_access_token"
  add_index "plaid_rails_accounts", ["owner_id"], name: "index_plaid_rails_accounts_on_owner_id"
  add_index "plaid_rails_accounts", ["plaid_id"], name: "index_plaid_rails_accounts_on_plaid_id"

  create_table "plaid_rails_webhooks", force: true do |t|
    t.integer  "code"
    t.string   "message"
    t.string   "access_token"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_id"
    t.string   "webhook_type"
    t.string   "webhook_code"
    t.string   "error"
    t.integer  "new_transactions"
    t.text     "removed_transactions"
  end

end
