class SelectionsController < ApplicationController
before_action :signed_in_user, only: [:create, :destroy]
  
  def create
    @source_recipe = SourceRecipe.where(recipe_ref:             params[:selection][:recipe_ref], 
                                        name:                   params[:selection][:recipe_name], 
                                        ingredients:            params[:selection][:ingredients], 
                                        small_image_url:        params[:selection][:small_image_url], 
                                        total_time_in_seconds:  params[:selection][:total_time_in_seconds], 
                                        source_display_name:    params[:selection][:source_display_name],
                                        source:                 params[:selection][:source]
                                        ).first_or_create!
                                        
    logger.debug "source_recipe: #{@source_recipe.id} source_recipe_name: #{@source_recipe.name}"
    logger.debug "param platter_name: #{params[:selection][:platter_name]}"
    
    if (params[:selection][:platter_name]).blank?  
      if (params[:selection][:platter_id]).blank? # This is to take of Chrome & Safari where the user can select "Please select" item from Platter options
        flash[:error] = "Recipe NOT added to Platter!"
        redirect_to :back
      else      
        @selection = Platter.find(params[:selection][:platter_id]).selections.build(source_recipe_id: @source_recipe.id)
        if @selection.save
          pl = Platter.find(params[:selection][:platter_id])       #Update Platter's last_platter_activity_at field
          pl.update(last_platter_activity_at: DateTime.now.utc)
          flash[:success] = "Recipe added to Platter!"
          redirect_to :back
        else
          flash[:error] = "Recipe NOT added to Platter!"
          redirect_to :back 
        end
      end
    else
      @platter = Platter.where(name:  params[:selection][:platter_name], user_id: current_user).first_or_create!
      if @platter.nil?
          flash[:error] = "Could not be create Platter"
          redirect_to :back
      else
        @selection = @platter.selections.build(source_recipe_id: @source_recipe.id)
        if @selection.save
            flash[:success] = "Recipe added to Platter!"
            redirect_to :back
        else
          flash[:error] = "Recipe NOT added to Platter!"
          redirect_to :back 
        end
      end
    end
  end
  
  def destroy
  end
  
  private 
  def selection_params
    params.require(:selection).permit(:platter_id, :source_recipe_id, :recipe_ref, :recipe_name, :ingredients, :small_image_url, 
                      :total_time_in_seconds, :source_display_name, :source, :platter_name)
  end
end
