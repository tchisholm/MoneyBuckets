class CreateAbuckets < ActiveRecord::Migration
  def self.up
    create_table :abuckets do |t|
      t.string :name
      t.integer :account_id
    end
    add_index :abuckets, [:account_id, :name], :unique => true
  end

  def self.down
    remove_index :abuckets, :column => [:account_id, :name]
    drop_table :abuckets
  end
end
