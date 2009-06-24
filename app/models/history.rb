class History < ActiveRecord::Base
  
  belongs_to :account
  validates_existence_of :account
  has_many :hbuckets, :dependent => :destroy
  validates_presence_of :tran_date
  
  def sum_allocation_buckets(type)
    amount = 0
    self.hbuckets.find(:all).each do |b|
      if type == 'Withdrawal' and b.wamount != nil
        amount += b.wamount
      end
      if type == 'Deposit' and b.damount != nil
        amount += b.damount
      end
    end
    amount
  end
  
  def find_budget_buckets(account)
    account.recurrings.find_by_transaction_type('Budget').rbuckets.find(:all)
  end
  
  def get_bucket_balance(account, abucket_id)
    amount = 0
    account.transactions.find(:all).each do |t|
      t.hbuckets.find_all_by_abucket_id(abucket_id).each do |b|
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
  
  def find_ubuckets(abuckets)
    unallocated_buckets = []
    abuckets.each do |bucket|
      if !self.hbuckets.find_by_abucket_id(bucket.id)
        unallocated_buckets << bucket
      end
    end
    unallocated_buckets
  end
  
end
