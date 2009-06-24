class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :account_id
      t.date :tran_date
      t.datetime :created_at
      t.integer :recur_id
      t.string :doc_number
      t.string :description
      t.decimal :damount
      t.decimal :wamount
      t.boolean :reconciled
    end
    add_index :transactions, [:account_id, :tran_date, :created_at], :unique => true
  end

  def self.down
    remove_index :transactions, :column => [:account_id, :tran_date, :created_at]
    drop_table :transactions
  end
end
