class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :account_id
      t.date :tran_date
      t.datetime :created_at
      t.integer :recur_id
      t.string :doc_number
      t.string :description
      t.decimal :damount
      t.decimal :wamount
    end
    add_index :histories, [:account_id, :tran_date, :created_at], :unique => true
  end

  def self.down
    remove_index :histories, :column => [:account_id, :tran_date, :created_at]
    drop_table :histories
  end
end
