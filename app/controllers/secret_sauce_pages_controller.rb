class SecretSaucePagesController < ApplicationController
  
  def home
    if signed_in?
      # @recipe = current_user.recipe.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      # logger.debug "feed_items count: #{@feed_items.count}"
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
