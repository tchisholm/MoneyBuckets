class TransactionsController < ApplicationController
  layout 'main'

  before_filter :find_account, :except => [:reconcile, :unreconcile]
  before_filter :find_transaction, :except => [:index, :new, :create, :reconcile, :unreconcile]
  
  # GET /transactions
  # GET /transactions.xml
  def index
    @help = "Transaction List"
    @transactions = @account.transactions.find(:all, :order => "tran_date desc, created_at desc")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @help = "New Transaction"
    @transaction = @account.transactions.build
    @recurrings = @account.recurrings.find(:all, :conditions => "transaction_type != 'Budget'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @help = "Edit Transaction"
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = @account.transactions.build(params[:transaction])
    @transaction.created_at = Time.now
    if @transaction.recur_id != nil
      @transaction.doc_number = nil
      @recurring = @account.recurrings.find(@transaction.recur_id)
      @transaction.description = @recurring.name
      if @recurring.transaction_type == 'Withdrawal'
        @transaction.wamount = @recurring.amount
        @transaction.damount = nil
      else
        @transaction.damount = @recurring.amount
        @transaction.wamount = nil
      end
    end
    respond_to do |format|
      if @transaction.save
        # do bucket allocation
        if @transaction.recur_id != nil
          @recurring.rbuckets.each do |r|
            @tbucket = Tbucket.new
            @tbucket.abucket_id = r.abucket_id
            @tbucket.transaction_id = @transaction.id
            if @recurring.transaction_type == 'Withdrawal'
              @tbucket.wamount = r.amount
            else
              @tbucket.damount = r.amount
            end
            @tbucket.save
          end
        end
        flash[:notice] = 'Transaction was successfully created.'
        format.html { redirect_to(account_transactions_path(@account)) }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        flash[:notice] = 'Transaction was successfully updated.'
        format.html { redirect_to(account_transactions_path(@account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to(account_transactions_path(@account)) }
      format.xml  { head :ok }
    end
  end
  
  def reconcile
    @transaction = Transaction.find(params[:id])
    @account = current_user.accounts.find(@transaction.account_id)
    @transaction.update_attribute(:reconciled, true)
    redirect_to :action => "index", :account_id => @account
  end
  
  def unreconcile
    @transaction = Transaction.find(params[:id])
    @account = current_user.accounts.find(@transaction.account_id)
    @transaction.update_attribute(:reconciled, false)
    redirect_to :action => "index", :account_id => @account
  end
  
private

  # get_account converts the account_id given by the routing
  # into  an @account object, for use here and in the view.
  def find_account
    @account = Account.find(params[:account_id])
  end
  
  def find_transaction
    @transaction = @account.transactions.find(params[:id])
  end
  
end
