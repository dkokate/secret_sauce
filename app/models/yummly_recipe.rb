 class YummlyRecipe
  
  attr_accessor :id, :course, :flavors, :rating, :smallImageUrls, :sourceDisplayName, :totalTimeInSeconds, 
                :ingredients, :recipeName, :sourceDisplayName, :criteria
  
  def initialize(attributes={})
    @id     = attributes[:id]
    @course = attributes[:course]
    @flavors = attributes[:flavors]
    @rating = attributes[:rating]
    @smallImageUrls = attributes[:smallImageUrls]
    @totalTimeInSeconds = attributes[:totalTimeInSeconds]
    @ingredients = attributes[:ingredients]
    @recipeName = attributes[:recipeName]
    @sourceDisplayName = attributes[:sourceDisplayName]
    @criteria = attributes[:criteria]
  end
end