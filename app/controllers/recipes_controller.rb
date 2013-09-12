class RecipesController < ApplicationController
  before_action :signed_in_user, only:[:new, :create, :edit, :update, :destroy]
  before_action :correct_recipe_author, only:[:edit, :update, :destroy]
  
  def new
    @recipe = current_user.recipes.build if signed_in?
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      flash[:success] = "Recipe Published"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
      @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(recipe_params)
      flash[:success] = "Recipe updated"
      # logger.debug "Recipe attributes AFTER Update: #{@recipe.attributes.inspect}"
      redirect_to @recipe.user
    else
      render 'edit'
    end
  end

  def destroy
    @recipe.destroy
    redirect_to root_url
  end
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :instructions, :total_calories)
    end

    def correct_recipe_author
      @user = (Recipe.find(params[:id])).user
      @recipe = Recipe.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end