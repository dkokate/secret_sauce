class PlattersController < ApplicationController
  
  before_action :signed_in_user, only:[:create, :edit, :update, :destroy]
  before_action :correct_platter_owner, only:[:edit, :update, :destroy]

  def show
    @platter = Platter.find(params[:id])
    @selections = @platter.selections.paginate(page: params[:page])
  end

  def create
    @platter = current_user.platters.build(platter_params)
    if @platter.save
      flash[:success] = "Platter Created"
      redirect_to :back         # user_path(@platter.user)
    else
      redirect_back_or root_url
    end
  end

  def edit
    @platter = Platter.find(params[:id])
  end

  def update
    @platter = Platter.find(params[:id])
    if @platter.update_attributes(platter_params)
      flash[:success] = "Platter updated"
      # logger.debug "Platter attributes AFTER Update: #{@platter.attributes.inspect}"
      redirect_to @platter.user
    else
      render 'edit'
    end
  end

  def destroy
    @platter.destroy
    redirect_to user_path(@platter.user)
  end

  private
    def platter_params
      params.require(:platter).permit(:name)
    end

    def correct_platter_owner
      @user = (Platter.find(params[:id])).user
      @platter = Platter.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
