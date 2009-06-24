class Abucket < ActiveRecord::Base
  
  belongs_to :account
  validates_existence_of :account
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:account_id]
  
  def get_bucket_balance(account)
    amount = 0
    account.transactions.find(:all).each do |t|
      t.tbuckets.find_all_by_abucket_id(self.id).each do |b|
        if b.damount != nil
          amount += b.damount
        end
        if b.wamount != nil
          amount -= b.wamount
        end
      end
    end
    amount
  end
  
end
