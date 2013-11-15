class InterestsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @platter = Platter.find(params[:interest][:platter_id])
    current_user.follow_platter!(@platter)
    respond_to do |format|
      format.html { redirect_to @platter }
      format.js
    end
  end

  def destroy
    @platter = Interest.find(params[:id]).platter
    current_user.unfollow_platter!(@platter)
    respond_to do |format|
      format.html { redirect_to @platter }
      format.js
    end
  end
end
