class YummlyRecipesController < ApplicationController
  before_filter :check_for_cancel, :only => [:new, :index]

  def new
  end
  
  def index
    logger.debug "In YummlyRecipesController#index params : #{params}"
    @yummly_recipes = (YummlyRecipeStore.new).find(params[:yummly_recipe]).paginate page: params[:page], per_page: 10
  end
  
  def show
    @yummly_recipe_detail = (YummlyRecipeStore.new).get_recipe(params[:id])
    # logger.debug "In YummlyRecipesController#show yummly_recipe_detail : #{@yummly_recipe_detail.inspect}"
    respond_to do |format|
      format.html 
      format.js
    end
  end
  
  
  def check_for_cancel
    if params['Cancel'] 
      redirect_to root_url
    end
  end
end
