require 'faraday'
require 'json'
 
class YummlyRecipeStore
  
  attr_accessor :conn
  
  def initialize
    @conn = Faraday.new(:url => 'http://api.yummly.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
  
  def find(options={})
    response = @conn.get do |req|                           
      req.url '/v1/api/recipes'
      req.headers['X-Yummly-App-ID'] = ENV["YUMMLY_ID"]
      req.headers['X-Yummly-App-Key'] = ENV["YUMMLY_KEY"]
      puts "Options: #{options}"
      req.params['q'] = options[:containing]
      
      req.params['allowedCourse'] = options[:allowed_course] unless options[:allowed_course].blank?
      
      req.params['allowedCuisine'] = options[:allowed_cuisine] unless options[:allowed_cuisine].blank?
      
      #if !options[:ingredients_included].blank?
      #  options[:ingredients_included].split( /, */ ).each do |ingredient|
      #    puts ingredient
      #    req.params['allowedIngredient'] = ingredient
      #  end
      #end
      req.params['allowedIngredient'] = options[:ingredients_included].split( /, */ ).map(&:downcase) unless options[:ingredients_included].blank?
      # Yummly requires ingredients to be in downcase
      # req.params['allowedIngredient'] = options[:ingredients_included] unless options[:ingredients_included].blank?
      
      req.params['excludedIngredient'] = options[:ingredients_excluded].split( /, */ ).map(&:downcase) unless options[:ingredients_excluded].blank?
      unless (options[:max_total_time_hr].blank? && options[:max_total_time_min].blank?)
        req.params['maxTotalTimeInSeconds'] = ((options[:max_total_time_hr] || 0).to_f * 60 * 60).round  +
                                              ((options[:max_total_time_min]).to_f * 60).round + 60
      end
      
      req.params['nutrition.ENERC_KCAL.min'] = 1 unless options[:max_calories].blank?
      req.params['nutrition.ENERC_KCAL.max'] = (options[:max_calories]).to_f.round unless options[:max_calories].blank?
      req.params['allowedAllergy'] = options[:allowed_allergy] unless options[:allowed_allergy].blank?
      req.params['maxResult'] = options[:maxResult] || 100
    end
    # puts "response body:  #{response.body}"
    # response.body
    parsed_json = ActiveSupport::JSON.decode(response.body)
    matched_data = parsed_json["matches"]
    yummly_recipes = []
    matched_data.each do |rec|
      yummly_recipe = YummlyRecipe.new(rec)
      # puts "In YummlyRecipeStore.find yummly_recipe : #{yummly_recipe.recipeName}"
      yummly_recipes << yummly_recipe
    end
  end
  
  def get_recipe(options={})
    response = @conn.get do |req|                           
      req.url '/v1/api/recipe/' + options
      req.headers['X-Yummly-App-ID'] = ENV["YUMMLY_ID"]
      req.headers['X-Yummly-App-Key'] = ENV["YUMMLY_KEY"]
    end
    parsed_json = ActiveSupport::JSON.decode(response.body)
      yummly_recipe_detail = YummlyRecipeDetail.new(parsed_json)
      # puts "In YummlyRecipeStore.get_recipe parsed_json : #{parsed_json["name"]}"
      # puts "In YummlyRecipeStore.get_recipe yummly_recipe_detail : #{yummly_recipe_detail.name}"
      return yummly_recipe_detail
  end

  def self.interesting_recipes_feed
    options = [
                [ :allowed_course, "course^course-Lunch and Snacks"], 
                [ :allowed_course, "course^course-Desserts"], 
                [ :allowed_course, "Salads","course^course-Salads"],
                [ :allowed_course, "course^course-Main Dishes"],
                
                [ :allowed_cuisine, "cuisine^cuisine-italian"], 
                [ :allowed_cuisine, "cuisine^cuisine-american"],
                [ :allowed_cuisine, "cuisine^cuisine-asian"],
                [ :allowed_cuisine, "cuisine^cuisine-chinese"],
                [ :allowed_cuisine, "cuisine^cuisine-japanese"],
                [ :allowed_cuisine, "cuisine^cuisine-thai"]
              ]
    indx = rand(0..options.length-1)
    sel_option = options[indx]
    #puts "indx: #{indx} sel_option: #{sel_option}"
    #puts "sel_option[0] = #{sel_option[0]}, sel_option[1] = #{sel_option[1]}"
    params = {}
    #params[:yummly_recipe] = { allowed_course: ["course^course-Desserts"], maxResult: 10 }
    params[:yummly_recipe] = { sel_option[0] => [sel_option[1]], maxResult: 10 }
    @interesting_recipes = (YummlyRecipeStore.new).find(params[:yummly_recipe])
  end

end