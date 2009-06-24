class CreateTbuckets < ActiveRecord::Migration
  def self.up
    create_table :tbuckets do |t|
      t.integer :abucket_id
      t.integer :transaction_id
      t.decimal :damount
      t.decimal :wamount
    end
    add_index :tbuckets, [:transaction_id, :abucket_id], :unique => true
  end

  def self.down
    remove_index :tbuckets, :column => [:transaction_id, :abucket_id]
    drop_table :tbuckets
  end
end
