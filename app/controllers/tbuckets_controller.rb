class TbucketsController < ApplicationController
  layout 'main'

  before_filter :find_transaction
  before_filter :find_account
  before_filter :find_abuckets
  before_filter :find_tbucket, :except => [:index, :new, :create]
  
  # GET /tbuckets
  # GET /tbuckets.xml
  def index
    @help = "Transaction Bucket List"
    @tbuckets = @transaction.tbuckets
    if @transaction.wamount != 0 and @transaction.wamount != nil
      @wremaining = @transaction.wamount - @transaction.sum_allocation_buckets('Withdrawal')
    else
      @wremaining = 0
    end
    if @transaction.damount != 0 and @transaction.damount != nil
      @dremaining = @transaction.damount - @transaction.sum_allocation_buckets('Deposit')
    else
      @dremaining = 0
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tbuckets }
    end
  end

  # GET /tbuckets/1
  # GET /tbuckets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tbucket }
    end
  end

  # GET /tbuckets/new
  # GET /tbuckets/new.xml
  def new
    @help = "New Transaction Bucket"
    @tbuckets = @transaction.tbuckets
    @bbuckets = @transaction.find_budget_buckets(@account)
    @ubuckets = @transaction.find_ubuckets(@abuckets)
    @tbucket = @transaction.tbuckets.build
    @wremaining = @transaction.set_wremaining
    @dremaining = @transaction.set_dremaining
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tbucket }
    end
  end

  # GET /tbuckets/1/edit
  def edit
    @help = "Edit Transaction Bucket"
    @tbuckets = @transaction.tbuckets
    @bbuckets = @transaction.find_budget_buckets(@account)
    @wremaining = @transaction.set_wremaining
    @dremaining = @transaction.set_dremaining
  end

  # POST /tbuckets
  # POST /tbuckets.xml
  def create
    @tbucket = @transaction.tbuckets.build(params[:tbucket])
    respond_to do |format|
      if @tbucket.save
        flash[:notice] = 'Tbucket was successfully created.'
        format.html { redirect_to(transaction_tbuckets_path(@transaction)) }
        format.xml  { render :xml => @tbucket, :status => :created, :location => @tbucket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tbucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tbuckets/1
  # PUT /tbuckets/1.xml
  def update
    respond_to do |format|
      if @tbucket.update_attributes(params[:tbucket])
        flash[:notice] = 'Tbucket was successfully updated.'
        format.html { redirect_to(transaction_tbuckets_path(@transaction)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tbucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tbuckets/1
  # DELETE /tbuckets/1.xml
  def destroy
    @tbucket.destroy
    respond_to do |format|
      format.html { redirect_to(transaction_tbuckets_path(@transaction)) }
      format.xml  { head :ok }
    end
  end
  
private

  def find_transaction
    @transaction = Transaction.find(params[:transaction_id])
  end
  
  def find_account
    @account = Account.find(@transaction.account_id)
  end
  
  def find_abuckets
    @abuckets = @account.abuckets.find(:all)
  end
  
  def find_tbucket
    @tbucket = @transaction.tbuckets.find(params[:id])
  end
  
end
