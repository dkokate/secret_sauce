class YummlyRecipesController < ApplicationController
  def new
  end
  
  def index
    # logger.debug "In YummlyRecipesController#index params : #{params}"
    @yummly_recipes = (YummlyRecipeStore.new).find(params[:yummly_recipe][:containing])
  end
  
  def show
    @yummly_recipe_detail = (YummlyRecipeStore.new).get_recipe(params[:id])
    # logger.debug "In YummlyRecipesController#show yummly_recipe_detail : #{@yummly_recipe_detail.inspect}"
  end
end
