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
      req.params['q'] = options
      req.params['maxResult'] = 30
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

end