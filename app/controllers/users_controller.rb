class UsersController < ApplicationController
  layout 'main'

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
  end

  def edit
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    # add default buckets
    @bucket = Bucket.new
    @bucket.name = "Alarm System"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Cable/Satelite"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Car Insurance"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Car Payment 1"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Car Payment 2"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Car Repair and Maintenance"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Car Taxes and Registration"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Cell Phone"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Christmas/Holidays"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Clothing"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Entertainment"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Food"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Gas"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Gifts"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Hair Care"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Home Insurance"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Home Owners Association"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "House Payment/Rent"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Income Taxes"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Life Insurance"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Medical"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Miscellaneous"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Savings"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Utilities - Electricity"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Utilities - Gas"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Utilities - Phone"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Utilities - Sewer and Garbage"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Utilities - Water"
    @bucket.user_id = @user.id
    @bucket.save
    @bucket = Bucket.new
    @bucket.name = "Vacation"
    @bucket.user_id = @user.id
    @bucket.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_to(helppage_path("General Instructions"))
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(user_accounts_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    User.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to(userinfo_path) }
      format.xml  { head :ok }
    end
  end

end
