class Recurring < ActiveRecord::Base

  TRANSACTION_TYPES = [
    #  Displayed                    stored in db
    [ "Deposit",            "Deposit" ],
    [ "Withdrawal",       "Withdrawal" ]
  ]
  
  belongs_to :account
  validates_existence_of :account
  has_many :rbuckets, :dependent => :destroy
  validates_presence_of :name, :amount
  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:account_id]
  validates_numericality_of :amount
  
  def sum_allocation_buckets
    amount = 0
    amount = self.rbuckets.find(:all).sum { |bucket| bucket.amount }
    amount
  end
  
  def find_budget_buckets(account)
    account.recurrings.find_by_transaction_type('Budget').rbuckets.find(:all)
  end
  
  def budget_amount(account, abucket_id)
    amount = 0
    budget = account.recurrings.find_by_transaction_type('Budget').rbuckets.find_by_abucket_id(abucket_id)
    if budget
      amount = budget.amount
    end
    amount
  end
  
  def remaining_amount(account, abucket_id)
    b_amount = self.budget_amount(account,abucket_id)
    d_amount = 0
    account.recurrings.find_all_by_transaction_type_and_monthly('Deposit', true).each do |r|
      if r.rbuckets.find_by_abucket_id(abucket_id)
        d_amount += r.rbuckets.find_by_abucket_id(abucket_id).amount
      end
    end
    b_amount - d_amount
  end
  
  def find_ubuckets(abuckets)
    unallocated_buckets = []
    abuckets.each do |bucket|
      if !self.rbuckets.find_by_abucket_id(bucket.id)
        unallocated_buckets << bucket
      end
    end
    unallocated_buckets
  end
  
  def monthly_deposit_amount(account)
    account.recurrings.find_all_by_transaction_type_and_monthly('Deposit', true).sum { |r| r.amount }
  end
  
end
