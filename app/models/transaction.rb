class Transaction < ActiveRecord::Base
  
  belongs_to :account
  validates_existence_of :account
  has_many :tbuckets, :dependent => :destroy
  validates_presence_of :tran_date
  
  def sum_allocation_buckets(type)
    amount = 0
    self.tbuckets.find(:all).each do |b|
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
      t.tbuckets.find_all_by_abucket_id(abucket_id).each do |b|
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
      if !self.tbuckets.find_by_abucket_id(bucket.id)
        unallocated_buckets << bucket
      end
    end
    unallocated_buckets
  end
  
  def update_balance(balance)
    if damount != nil
      balance += damount
    end
    if wamount != nil
      balance -= wamount
    end
    balance
  end
  
  def set_wremaining
    if tbuckets.count > 0
      if wamount != 0 and wamount != nil
        wremaining = wamount - sum_allocation_buckets('Withdrawal')
      else
        wremaining = 0
      end
    else
      if wamount != 0 and wamount != nil
        wremaining = wamount
      else
        wremaining = 0
      end
    end
    wremaining
  end
  
  def set_dremaining
    if tbuckets.count > 0
      if damount != 0 and damount != nil
        dremaining = damount - sum_allocation_buckets('Deposit')
      else
        dremaining = 0
      end
    else
      if damount != 0 and damount != nil
        dremaining = damount
      else
        dremaining = 0
      end
    end
    dremaining
  end
  
end
