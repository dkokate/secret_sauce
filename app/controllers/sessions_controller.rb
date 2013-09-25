class SessionsController < ApplicationController
  
  before_filter :check_for_cancel, :only => [:create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign in the user & redirect to show page
      sign_in(user, options = { :remember_me => params[:remember_me] })
      redirect_back_or root_url
      #redirect_back_or user
    else
      # Create error message
      # Since render 'new' does not count as a new request,
      # the flash error message persists after user navigates to a new page
      # Hence, flash.now is used
      flash.now[:error]  = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
  def check_for_cancel
    if params['Cancel'] 
      redirect_back_or root_url
    end
  end
  
end
