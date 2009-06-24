class RbucketsController < ApplicationController
  layout 'main'

  before_filter :find_recurring
  before_filter :find_account
  before_filter :find_abuckets
  before_filter :find_rbucket, :except => [:index, :new, :create]
  
  # GET /rbuckets
  # GET /rbuckets.xml
  def index
    @help = "Recurring Transaction Bucket List"
    @rbuckets = @recurring.rbuckets
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rbuckets }
    end
  end

  # GET /rbuckets/1
  # GET /rbuckets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rbucket }
    end
  end

  # GET /rbuckets/new
  # GET /rbuckets/new.xml
  def new
    @help = "New Recurring Transaction Bucket"
    @rbuckets = @recurring.rbuckets
    @bbuckets = @recurring.find_budget_buckets(@account)
    @ubuckets = @recurring.find_ubuckets(@abuckets)
    @rbucket = @recurring.rbuckets.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rbucket }
    end
  end

  # GET /rbuckets/1/edit
  def edit
    @help = "Edit Recurring Transaction Bucket"
    @rbuckets = @recurring.rbuckets
  end

  # POST /rbuckets
  # POST /rbuckets.xml
  def create
    @rbucket = @recurring.rbuckets.build(params[:rbucket])
    respond_to do |format|
      if @rbucket.save
        flash[:notice] = 'Rbucket was successfully created.'
        format.html { redirect_to(recurring_rbuckets_path(@recurring)) }
        format.xml  { render :xml => @rbucket, :status => :created, :location => @rbucket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rbucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rbuckets/1
  # PUT /rbuckets/1.xml
  def update
    respond_to do |format|
      if @rbucket.update_attributes(params[:rbucket])
        flash[:notice] = 'Rbucket was successfully updated.'
        format.html { redirect_to(recurring_rbuckets_path(@recurring)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rbucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rbuckets/1
  # DELETE /rbuckets/1.xml
  def destroy
    @rbucket.destroy
    respond_to do |format|
      format.html { redirect_to(recurring_rbuckets_path(@recurring)) }
      format.xml  { head :ok }
    end
  end
  
private

  def find_recurring
    @recurring = Recurring.find(params[:recurring_id])
  end
  
  def find_account
    @account = Account.find(@recurring.account_id)
  end
  
  def find_abuckets
    @abuckets = @account.abuckets.find(:all)
  end
  
  def find_rbucket
    @rbucket = @recurring.rbuckets.find(params[:id])
  end
  
end
