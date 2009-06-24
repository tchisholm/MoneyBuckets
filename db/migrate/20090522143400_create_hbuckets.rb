class CreateHbuckets < ActiveRecord::Migration
  def self.up
    create_table :hbuckets do |t|
      t.integer :abucket_id
      t.integer :history_id
      t.decimal :damount
      t.decimal :wamount
    end
    add_index :hbuckets, [:history_id, :abucket_id], :unique => true
  end

  def self.down
    remove_index :hbuckets, :column => [:history_id, :abucket_id]
    drop_table :hbuckets
  end
end
