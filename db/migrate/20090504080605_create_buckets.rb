class CreateBuckets < ActiveRecord::Migration
  def self.up
    create_table :buckets do |t|
      t.string :name
      t.integer :user_id
    end
    add_index :buckets, [:user_id, :name], :unique => true
  end

  def self.down
    remove_index :buckets, :column => [:user_id, :name]
    drop_table :buckets
  end
end
