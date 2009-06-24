# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090522183445) do

  create_table "abuckets", :force => true do |t|
    t.string  "name"
    t.integer "account_id"
  end

  add_index "abuckets", ["account_id", "name"], :name => "index_abuckets_on_account_id_and_name", :unique => true

  create_table "accounts", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  add_index "accounts", ["user_id", "name"], :name => "index_accounts_on_user_id_and_name", :unique => true

  create_table "buckets", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  add_index "buckets", ["user_id", "name"], :name => "index_buckets_on_user_id_and_name", :unique => true

  create_table "hbuckets", :force => true do |t|
    t.integer "abucket_id"
    t.integer "history_id"
    t.decimal "damount"
    t.decimal "wamount"
  end

  add_index "hbuckets", ["history_id", "abucket_id"], :name => "index_hbuckets_on_history_id_and_abucket_id", :unique => true

  create_table "helppages", :force => true do |t|
    t.string "name"
    t.text   "page_text"
  end

  create_table "histories", :force => true do |t|
    t.integer  "account_id"
    t.date     "tran_date"
    t.datetime "created_at"
    t.integer  "recur_id"
    t.string   "doc_number"
    t.string   "description"
    t.decimal  "damount"
    t.decimal  "wamount"
  end

  add_index "histories", ["account_id", "tran_date", "created_at"], :name => "index_histories_on_account_id_and_tran_date_and_created_at", :unique => true

  create_table "rbuckets", :force => true do |t|
    t.integer "abucket_id"
    t.integer "recurring_id"
    t.decimal "amount"
  end

  add_index "rbuckets", ["recurring_id", "abucket_id"], :name => "index_rbuckets_on_recurring_id_and_abucket_id", :unique => true

  create_table "recurrings", :force => true do |t|
    t.string  "name"
    t.integer "account_id"
    t.string  "transaction_type"
    t.decimal "amount"
    t.boolean "monthly"
  end

  add_index "recurrings", ["account_id", "name"], :name => "index_recurrings_on_account_id_and_name", :unique => true

  create_table "tbuckets", :force => true do |t|
    t.integer "abucket_id"
    t.integer "transaction_id"
    t.decimal "damount"
    t.decimal "wamount"
  end

  add_index "tbuckets", ["transaction_id", "abucket_id"], :name => "index_tbuckets_on_transaction_id_and_abucket_id", :unique => true

  create_table "transactions", :force => true do |t|
    t.integer  "account_id"
    t.date     "tran_date"
    t.datetime "created_at"
    t.integer  "recur_id"
    t.string   "doc_number"
    t.string   "description"
    t.decimal  "damount"
    t.decimal  "wamount"
    t.boolean  "reconciled"
  end

  add_index "transactions", ["account_id", "tran_date", "created_at"], :name => "index_transactions_on_account_id_and_tran_date_and_created_at", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "admin",                                   :default => false, :null => false
  end

end
