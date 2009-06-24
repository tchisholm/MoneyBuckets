class AccountsController < ApplicationController
  layout 'main'

  before_filter :find_account, :except => [:index, :new, :create]
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = current_user.accounts
    @help = "Account List"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = current_user.accounts.build
    @help = "New Account"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @help = "Edit Account"
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = current_user.accounts.build(params[:account])
    respond_to do |format|
      if @account.save
        # add budget RT
        @recurring = Recurring.new
        @recurring.name = "Monthly Budget"
        @recurring.account_id = @account.id
        @recurring.transaction_type = "Budget"
        @recurring.amount = 0
        @recurring.monthly = true
        @recurring.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(user_accounts_path(current_user)) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(user_accounts_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to(user_accounts_path(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  # Budget Report
  def budget_report
    @budget = @account.find_budget
    @bbuckets = @account.find_budget_buckets
    @deposits = @account.find_monthly_deposits
  end
  
  # Transaction Detail Report
  def transaction_detail_report
    @balance = 0
  end
  
  # Purge Transactions
  def archive_transactions_list
    @help = "Archive Transactions"
  end
  
  # Purge Transactions
  def archive_transactions
    #find account's balance forward
    @balance_forward = @account.transactions.find_by_description('Balance Forward')
    tran_ids = params[:transactions]
    unless tran_ids.blank?
      tran_ids.each do |tran_id|
        # find transaction
        @transaction = @account.transactions.find(tran_id)
        # create transaction history
        @history = @account.histories.build
        @history.account_id = @transaction.account_id
        @history.tran_date = @transaction.tran_date
        @history.created_at = @transaction.created_at
        @history.recur_id = @transaction.recur_id
        @history.doc_number = @transaction.doc_number
        @history.description = @transaction.description
        @history.damount = @transaction.damount
        @history.wamount = @transaction.wamount
        @history.save
        # for each transaction bucket:
        @transaction.tbuckets.each do |b|
          # create hbucket record
          @hbucket = @history.hbuckets.build
          @hbucket.abucket_id = b.abucket_id
          @hbucket.history_id = @history.id
          @hbucket.damount = b.damount
          @hbucket.wamount = b.wamount
          @hbucket.save
          # find buckets' balance forward or create if not found
          @bucket_balance_forward = @balance_forward.tbuckets.find_by_abucket_id(b.abucket_id)
          if !@bucket_balance_forward
            @bucket_balance_forward = @balance_forward.tbuckets.build
            @bucket_balance_forward.abucket_id = b.abucket_id
            @bucket_balance_forward.transaction_id = @balance_forward.id
            @bucket_balance_forward.damount = 0
            @bucket_balance_forward.save
          end
          # calculate new bucket balance forward amount
          amount = @bucket_balance_forward.damount
          if b.damount != nil
            amount += b.damount
          end
          if b.wamount != nil
            amount -= b.wamount
          end
          # update bucket balance forward amount
          @bucket_balance_forward.update_attribute(:damount, amount)
          # delete transaction bucket
          b.destroy
        end
        # calculate new account balance forward amount
        amount = @balance_forward.damount
        if @transaction.damount != nil
          amount += @transaction.damount
        end
        if @transaction.wamount != nil
          amount -= @transaction.wamount
        end
        # update account balance forward amount
        @balance_forward.update_attribute(:damount, amount)
        # delete transaction
        @transaction.destroy
      end
    end
    redirect_to :action => 'index'
  end
  
  def view_archived_transactions
    @history = @account.histories.find(:all)
    @help = "Archived Transactions List"
  end
  
  # Purge Transactions
  def unarchive_transactions
    #find account's balance forward
    @balance_forward = @account.transactions.find_by_description('Balance Forward')
    tran_ids = params[:transactions]
    unless tran_ids.blank?
      tran_ids.each do |tran_id|
        # find history
        @history = @account.histories.find(tran_id)
        # create transaction
        @transaction = @account.transactions.build
        @transaction.account_id = @history.account_id
        @transaction.tran_date = @history.tran_date
        @transaction.created_at = @history.created_at
        @transaction.recur_id = @history.recur_id
        @transaction.doc_number = @history.doc_number
        @transaction.description = @history.description
        @transaction.damount = @history.damount
        @transaction.wamount = @history.wamount
        @transaction.reconciled = true
        @transaction.save
        # for each history bucket:
        @history.hbuckets.each do |b|
          # create tbucket record
          @tbucket = @transaction.tbuckets.build
          @tbucket.abucket_id = b.abucket_id
          @tbucket.transaction_id = @transaction.id
          @tbucket.damount = b.damount
          @tbucket.wamount = b.wamount
          @tbucket.save
          # find buckets' balance forward or create if not found
          @bucket_balance_forward = @balance_forward.tbuckets.find_by_abucket_id(b.abucket_id)
          if !@bucket_balance_forward
            @bucket_balance_forward = @balance_forward.tbuckets.build
            @bucket_balance_forward.abucket_id = b.abucket_id
            @bucket_balance_forward.transaction_id = @balance_forward.id
            @bucket_balance_forward.damount = 0
            @bucket_balance_forward.save
          end
          # calculate new bucket balance forward amount
          amount = @bucket_balance_forward.damount
          if b.damount != nil
            amount -= b.damount
          end
          if b.wamount != nil
            amount += b.wamount
          end
          # update bucket balance forward amount
          @bucket_balance_forward.update_attribute(:damount, amount)
          # delete history bucket
          b.destroy
        end
        # calculate new account balance forward amount
        amount = @balance_forward.damount
        if @transaction.damount != nil
          amount -= @transaction.damount
        end
        if @transaction.wamount != nil
          amount += @transaction.wamount
        end
        # update account balance forward amount
        @balance_forward.update_attribute(:damount, amount)
        # delete history
        @history.destroy
      end
    end
    redirect_to :action => 'index'
  end
  
  def purge_archived_transactions
    @history = @account.histories.find(:all)
    @help = "Purge Archived Transactions"
  end
  
  def purge_transactions
    tran_ids = params[:transactions]
    unless tran_ids.blank?
      tran_ids.each do |tran_id|
        # find history
        @history = @account.histories.find(tran_id)
        # delete history
        @history.destroy
      end
    end
    redirect_to :action => 'index'
  end
  
private  
  
  def find_account
    @account = current_user.accounts.find(params[:id])
  end
  
end
