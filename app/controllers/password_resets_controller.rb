class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    # logger.debug "Params AFTER reset form submission: #{params}"
    user = User.find_by(email: params[:password_reset][:email].downcase)
    if user
      user.send_password_reset 
      redirect_to root_url, :notice => "Password reset instructions have been emailed to you"
    else
      flash.now[:error]  = "Invalid email address"
      render 'new'
    end
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    logger.debug "Params BEFORE update: #{params}"
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Sorry; Password reset has expired. Please submit reset password request again"
    elsif @user.update_attributes(params.require(:user).permit(:name, :email, :password, :password_confirmation, :password_reset_token))
      sign_in(@user)
      redirect_to root_url, notice: "Welcome back! Your password has been reset."
    else
      render :edit
    end
  end

end
