class Account < ActiveRecord::Base
  
  belongs_to :user
  validates_existence_of :user
  has_many :abuckets, :dependent => :destroy
  has_many :recurrings, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :histories, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:user_id]
  
  def get_balance_forward
    @balance_forward = transactions.find_by_description('Balance Forward')
  end
  
  def get_account_balance
    get_balance_forward
    if !@balance_forward
      @balance_forward = transactions.build
      @balance_forward.account_id = id
      @balance_forward.tran_date = "01/01/1900".to_date
      @balance_forward.created_at = "01/01/1900 01:00:00".to_time
      @balance_forward.description = "Balance Forward"
      @balance_forward.damount = 0
      @balance_forward.save
    end
    amount = @balance_forward.damount
    transactions.find(:all).each do |t|
      if t.description != 'Balance Forward'
        if t.damount != nil
          amount += t.damount
        end
        if t.wamount != nil
          amount -= t.wamount
        end
      end
    end
    amount
  end
  
  def get_reconciled_balance
    get_balance_forward
    amount = @balance_forward.damount
    @reconciled = transactions.find_all_by_reconciled(true)
    if @reconciled
      @reconciled.each do |t|
        if t.damount != nil
          amount += t.damount
        end
        if t.wamount != nil
          amount -= t.wamount
        end
      end
    end
    amount
  end
  
  def find_budget
    recurrings.find_by_transaction_type('Budget')
  end
  
  def find_budget_buckets
    find_budget.rbuckets
  end
  
  def find_monthly_deposits
    self.recurrings.find_all_by_transaction_type('Deposit')
  end
  
  def get_deposit_amount(deposit, abucket_id)
    @bucket = deposit.rbuckets.find_by_abucket_id(abucket_id)
    if @bucket
      @bucket.amount
    else
      0
    end
  end
  
  def get_bucket_balance(abucket_id)
    amount = 0
    transactions.find(:all).each do |t|
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
  
end
