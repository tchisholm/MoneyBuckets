class CreateRecurrings < ActiveRecord::Migration
  def self.up
    create_table :recurrings do |t|
      t.string :name
      t.integer :account_id
      t.string :transaction_type
      t.decimal :amount
      t.boolean :monthly
    end
    add_index :recurrings, [:account_id, :name], :unique => true
  end

  def self.down
    remove_index :recurrings, :column => [:account_id, :name]
   drop_table :recurrings
  end
end
