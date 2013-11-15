class SecretSaucePagesController < ApplicationController
  
  def home
    if signed_in?
      # @recipe = current_user.recipes.build # Not required since we are not creating a recipe in home page
      # @feed_items = current_user.feed.paginate(page: params[:page]) # Not required since we are no longer showing recipe feed on home page
      @platter_feed_items = current_user.platter_feed.paginate(page: params[:page])
      # logger.debug "feed_items count: #{@feed_items.count}"
      # logger.debug "platter_feed_items count: #{@platter_feed_items.count}"
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
