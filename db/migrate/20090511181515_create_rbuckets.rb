class CreateRbuckets < ActiveRecord::Migration
  def self.up
    create_table :rbuckets do |t|
      t.integer :abucket_id
      t.integer :recurring_id
      t.decimal :amount
    end
    add_index :rbuckets, [:recurring_id, :abucket_id], :unique => true
  end

  def self.down
    remove_index :rbuckets, :column => [:recurring_id, :abucket_id]
    drop_table :rbuckets
  end
end
