class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign in the user & redirect to show page
      sign_in(user)
      redirect_to user
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
end
