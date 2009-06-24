class BucketsController < ApplicationController
  layout 'main'
  
  before_filter :find_bucket, :except => [:index, :new, :create]
  
  # GET /buckets
  # GET /buckets.xml
  def index
    @buckets = current_user.buckets
    @help = "General Bucket List"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buckets }
    end
  end

  # GET /buckets/1
  # GET /buckets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/new
  # GET /buckets/new.xml
  def new
    @bucket = current_user.buckets.build
    @help = "New General Bucket"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @help = "Edit General Bucket"
  end

  # POST /buckets
  # POST /buckets.xml
  def create
    @bucket = current_user.buckets.build(params[:bucket])
    respond_to do |format|
      if @bucket.save
        flash[:notice] = 'Bucket was successfully created.'
        format.html { redirect_to(user_buckets_path(current_user)) }
        format.xml  { render :xml => @bucket, :status => :created, :location => @bucket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buckets/1
  # PUT /buckets/1.xml
  def update
    respond_to do |format|
      if @bucket.update_attributes(params[:bucket])
        flash[:notice] = 'Bucket was successfully updated.'
        format.html { redirect_to(user_buckets_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buckets/1
  # DELETE /buckets/1.xml
  def destroy
    @bucket.destroy
    respond_to do |format|
      format.html { redirect_to(user_buckets_path(current_user)) }
      format.xml  { head :ok }
    end
  end

private  
  
  def find_bucket
    @bucket = current_user.buckets.find(params[:id])
  end
  
end
