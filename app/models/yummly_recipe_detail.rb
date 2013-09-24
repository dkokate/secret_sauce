 class YummlyRecipeDetail
  
  attr_accessor :ingredientLines, :flavors, :nutritionEstimates, :nutritionEstimates, :largeImageUrl, :smallImageUrl, 
                :name, :yield, :totalTime, :attributes, :totalTimeInSeconds, :rating, :numberOfServings, :source, :id,
                :nutritionEstimates, :calories, :sourceRecipeUrl, :sourceDisplayName, :sourceSiteUrl, 
                :attribution_html, :attribution_url, :attribution_text, :attribution_logo
  
  def initialize(attributes={})
    @attribution_html = attributes["attribution"]["html"]
    @attribution_url = attributes["attribution"]["url"]
    @attribution_text = attributes["attribution"]["text"]
    @attribution_logo = attributes["attribution"]["logo"]
    
    @source = {}
    @source = attributes["source"]
    @sourceRecipeUrl = self.source["sourceRecipeUrl"]
    @sourceSiteUrl = self.source["sourceSiteUrl"]
    @sourceDisplayName = self.source["sourceDisplayName"]
    
    
    @ingredientLines     = attributes["ingredientLines"]
    @flavors = attributes["flavors"]
    @nutritionEstimates = attributes["nutritionEstimates"]
    @largeImageUrl = attributes["images"].first["hostedLargeUrl"]
    @smallImageUrl = attributes["images"].first["hostedSmallUrl"]
    @name = attributes["name"]
    @yield = attributes["yield"]
    @totalTime = attributes["totalTime"]
    @attributes = attributes["attributes"]
    @totalTimeInSeconds = attributes["totalTimeInSeconds"]
    @rating = attributes["rating"]
    @numberOfServings = attributes["numberOfServings"]
    @id = attributes["id"]
    
    @nutritionEstimates = {}


    # puts "NutriEstimates: #{attributes["nutritionEstimates"]}"
    attributes["nutritionEstimates"].each  do |nutri|
      case nutri["attribute"]
      when "FAT_KCAL" then  nutri_key = :fat_kcal;  @nutritionEstimates[nutri_key] = {}
      when "NA"       then nutri_key = :na;         @nutritionEstimates[nutri_key] = {}
      when "K"       then nutri_key = :k;           @nutritionEstimates[nutri_key] = {}
        # @nutritionEstimates[:na] = {desc: nutri['description'], value: nutri['value'], unit: nutri['unit']['abbreviation']}
      when "CHOLE"    then nutri_key = :chole;      @nutritionEstimates[nutri_key] = {}
      when "FATRN"    then nutri_key = :fatrn;      @nutritionEstimates[nutri_key] = {}
      when "FASAT"    then nutri_key = :fasat;      @nutritionEstimates[nutri_key] = {}
      when "CHOCDF"   then nutri_key = :chocdf;     @nutritionEstimates[nutri_key] = {}
      when "FIBTG"    then nutri_key = :fibtg;      @nutritionEstimates[nutri_key] = {}
      when "PROCNT"   then nutri_key = :procnt;     @nutritionEstimates[nutri_key] = {}
      when "VITC"     then nutri_key = :vitc;       @nutritionEstimates[nutri_key] = {}
      when "CA"       then nutri_key = :ca;         @nutritionEstimates[nutri_key] = {}
      when "FE"       then nutri_key = :fe;         @nutritionEstimates[nutri_key] = {}
      when "SUGAR"    then nutri_key = :sugar;      @nutritionEstimates[nutri_key] = {}
      when "ENERC_KCAL" then nutri_key = :enerc_kcal; @nutritionEstimates[nutri_key] = {}
      when "FAT"        then nutri_key = :fat;      @nutritionEstimates[nutri_key] = {}
      when "VITA_IU"    then nutri_key = :vita_iu;  @nutritionEstimates[nutri_key] = {}
      else               
        nutri_key = :unknow;  @nutritionEstimates[nutri_key] = {}
      end
      # puts "Nutr: #{nutri}"
      @nutritionEstimates[nutri_key][:desc] = nutri['description']
      @nutritionEstimates[nutri_key][:value] = nutri['value']
      @nutritionEstimates[nutri_key][:unit] = nutri['unit']['abbreviation']
    end 
    
    @calories = self.nutritionEstimates[:enerc_kcal][:value] unless self.nutritionEstimates[:enerc_kcal].blank?
    
    
    # @smallImageUrls = attributes[:smallImageUrls]
    # @totalTimeInSeconds = attributes[:totalTimeInSeconds]
    # @ingredients = attributes[:ingredients]
    # @recipeName = attributes[:recipeName]
  end
end