class UsersController < ApplicationController
  before_action :signed_in_user, only:[:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.order('name ASC').paginate(page: params[:page], per_page: 30)
  end
  
  def show
    @user = User.find(params[:id])
    # >> @recipes = @user.recipes.paginate(page: params[:page])
    @platters = @user.platters.order('last_platter_activity_at DESC').paginate(page: params[:page])
    store_location
    @platter = current_user.platters.build if signed_in?
  end
  
  def new
    if signed_in? 
      redirect_to root_url, notice: "You have already signed up"
    else
       @user = User.new
    end
  end
  
  def create
    if signed_in?
      redirect_to root_url, notice: "You have already signed up"
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        flash[:success] = "Enjoy the Secret Sauce!"
        # redirect_to @user
        redirect_to root_url
      else
        render 'new'
      end
    end
  end
  
  def edit
    # @user = User.find(params[:id])...not requried as @user is set in correct_user called in before_action
  end
  
  def update
    # @user = User.find(params[:id])...not requried as @user is set in correct_user called in before_action
    # logger.debug "User attributes BEFORE Update: #{@user.attributes.inspect}"
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      # logger.debug "User attributes AFTER Update: #{@user.attributes.inspect}"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :password_reset_token)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
end
