class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.integer :user_id
    end
    add_index :accounts, [:user_id, :name], :unique => true
  end

  def self.down
    remove_index :accounts, :column => [:user_id, :name]
    drop_table :accounts
  end
end
