class Tbucket < ActiveRecord::Base
  
  belongs_to :transaction
  validates_existence_of :transaction
  validates_presence_of :abucket_id
  validates_uniqueness_of :abucket_id, :case_sensitive => false, :scope => [:transaction_id]
  
  def update_balance(balance)
    if damount != nil
      balance += damount
    end
    if wamount != nil
      balance -= wamount
    end
    balance
  end
  
end
