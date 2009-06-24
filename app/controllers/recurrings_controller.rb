class RecurringsController < ApplicationController
  layout 'main'

  before_filter :find_account
  before_filter :find_recurring, :except => [:index, :new, :create]
  
  # GET /recurrings
  # GET /recurrings.xml
  def index
    @help = "Recurring Transaction List"
    @recurrings = @account.recurrings
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recurrings }
    end
  end

  # GET /recurrings/1
  # GET /recurrings/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recurring }
    end
  end

  # GET /recurrings/new
  # GET /recurrings/new.xml
  def new
    @help = "New Recurring Transaction"
    @recurring = @account.recurrings.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recurring }
    end
  end

  # GET /recurrings/1/edit
  def edit
    @help = "Edit Recurring Transaction"
  end

  # POST /recurrings
  # POST /recurrings.xml
  def create
    @recurring = @account.recurrings.build(params[:recurring])
    respond_to do |format|
      if @recurring.save
        flash[:notice] = 'Recurring Transaction was successfully created.'
        format.html { redirect_to(account_recurrings_path(@account)) }
        format.xml  { render :xml => @recurring, :status => :created, :location => @recurring }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recurring.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recurrings/1
  # PUT /recurrings/1.xml
  def update
    respond_to do |format|
      if @recurring.update_attributes(params[:recurring])
        flash[:notice] = 'Recurring Transaction was successfully updated.'
        format.html { redirect_to(account_recurrings_path(@account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recurring.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recurrings/1
  # DELETE /recurrings/1.xml
  def destroy
    @recurring.destroy
    respond_to do |format|
      format.html { redirect_to(account_recurrings_path(@account)) }
      format.xml  { head :ok }
    end
  end
  
private

  # get_account converts the account_id given by the routing
  # into  an @account object, for use here and in the view.
  def find_account
    @account = Account.find(params[:account_id])
  end
  
  def find_recurring
    @recurring = @account.recurrings.find(params[:id])
  end
  
end
