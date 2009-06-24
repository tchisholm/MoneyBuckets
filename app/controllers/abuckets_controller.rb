class AbucketsController < ApplicationController
  layout 'main'

  before_filter :find_account, :except => [:abucket_add, :transaction_detail_report]
  before_filter :find_abucket, :except => [:index, :new, :create, :abucket_add, :transaction_detail_report]
  # :get_account is defined at the bottom of the file,
  # and takes the account_id given by the routing and
  # converts it to an @account object.

  # GET /abuckets
  # GET /abuckets.xml
  def index
    @abuckets = @account.abuckets
    @help = "Bucket List"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @abuckets }
    end
  end

  # GET /abuckets/1
  # GET /abuckets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @abucket }
    end
  end

  # GET /abuckets/new
  # GET /abuckets/new.xml
  def new
    @help = "New Buckets"
    @abucket = Abucket.new
    @unassigned_buckets = []
    current_user.buckets.each do |bucket|
      if !@account.abuckets.find_by_name(bucket.name)
        @unassigned_buckets << bucket
      end
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @abucket }
    end
  end

  # GET /abuckets/1/edit
  def edit
    @help = "Edit Bucket"
  end

  # POST /abuckets
  # POST /abuckets.xml
  def create
    @abucket = @account.abuckets.build(params[:abucket])
    respond_to do |format|
      if @abucket.save
        flash[:notice] = 'Bucket was successfully assigned.'
        format.html { redirect_to(account_abuckets_path(@account)) }
        format.xml  { render :xml => @abucket, :status => :created, :location => @abucket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @abucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /abuckets/1
  # PUT /abuckets/1.xml
  def update
    respond_to do |format|
      if @abucket.update_attributes(params[:abucket])
        flash[:notice] = 'Bucket was successfully updated.'
        format.html { redirect_to(account_abuckets_path(@account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @abucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /abuckets/1
  # DELETE /abuckets/1.xml
  def destroy
    @abucket.destroy
    respond_to do |format|
      format.html { redirect_to(account_abuckets_path(@account)) }
      format.xml  { head :ok }
    end
  end

  def abucket_add
    @account = current_user.accounts.find(params[:id])
    #@abucket.cancel
    bucket_ids = params[:abuckets]
    unless bucket_ids.blank?
      bucket_ids.each do |bucket_id|
        @bucket = current_user.buckets.find(bucket_id)
        #add bucket to list using << operator
        #@account.abuckets << @abucket
        @abucket = Abucket.new
        @abucket.name = @bucket.name
        @abucket.account_id = params[:id]
        @abucket.save
      end
    end
    redirect_to :action => "index", :account_id => @account
  end

  # Transaction Detail Report
  def transaction_detail_report
    @abucket = Abucket.find(params[:id])
    @account = current_user.accounts.find(@abucket.account_id)
    @balance = 0
  end
  
private

  # get_account converts the account_id given by the routing
  # into  an @account object, for use here and in the view.
  def find_account
    @account = current_user.accounts.find(params[:account_id])
  end
  
  def find_abucket
    @abucket = @account.abuckets.find(params[:id])
  end
  
end
