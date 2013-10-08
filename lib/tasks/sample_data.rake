namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_recipes
    make_source_recipes
    make_platters
    make_relationships
  end
end

def make_users
 admin = User.create!(name: "Dilip Kokate",
               email: "dkokate@gmail.com",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)
  User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_recipes
  users = User.all(limit: 6)
  50.times do |n|
    # name = Faker::Lorem.sentence(2)
    # instructions = Faker::Lorem.sentence(3)
    name = "Secret Sauce-#{n}"
    instructions = "Abra-#{n} Dabra Mumbra-#{n}"
    users.each { |user| user.recipes.create!(name: name, instructions: instructions) }
  end
end

def make_source_recipes
  SourceRecipe.create!(recipe_ref:   "Mexican-corn-on-the-cob-306886",
                       name:  "Mexican corn on the cob",
                       ingredients:         "butter, mayonnaise, corn, lime, cheese, cayenne",
                       small_image_url:       "http://yummly-recipeimages-compressed.s3.amazonaws.com/Mexican-corn-on-the-cob-306886-270609.s.jpg",
                       total_time_in_seconds:  2100,
                       source_display_name:   "Homesick Texan",
                       source: "yummly")
                       
   SourceRecipe.create!(recipe_ref:  "Easy-creamed-corn-299633",
                        name: "Easy Creamed Corn",
                        ingredients:       "frozen whole kernel corn, cayenne pepper, Country Crock Spread, sliced green onions, fat free half and half",
                        small_image_url:     "http://yummly-recipeimages-compressed.s3.amazonaws.com/Easy-creamed-corn-299633-267975.s.jpg",
                        total_time_in_seconds: 480,
                        source_display_name: "Country Crock",                    
                        source: "yummly")

   SourceRecipe.create!(recipe_ref:    "Grilled-corn-with-bacon-butter-and-cotija-cheese-333613",
                        name:   "Grilled Corn with Bacon Butter and Cotija Cheese",
                        ingredients:         "butter, bacon, black pepper, olive oil, fresh cilantro, cheese, ears",
                        small_image_url:       "http://yummly-recipeimages-compressed.s3.amazonaws.com/Grilled-corn-with-bacon-butter-and-cotija-cheese-333613-295533.s.jpg",
                        total_time_in_seconds:  2400,
                        source_display_name: "How Sweet It Is",   
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Spiced-Corn-on-the-Cob-Martha-Stewart-196507",
                        name: "Spiced Corn on the Cob",
                        ingredients:         "butter, black pepper, corn, garlic, salt, scotch",
                        small_image_url:       "http://yummly-recipeimages-compressed.s3.amazonaws.com/Spiced-Corn-on-the-Cob-Martha-Stewart-196507-111832.s.png",
                        total_time_in_seconds:  3300,
                        source_display_name: "Martha Stewart" ,
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Tarragon-Corn-Simply-Recipes-42503",
                        name: "Tarragon Corn",
                        ingredients: "butter, shallots, fresh tarragon, corn, anise liqueur, unsalted butter, white pepper",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Tarragon-Corn-Simply-Recipes-42503-3768.s.jpg",
                        total_time_in_seconds: 0,
                        source_display_name: "Simply Recipes",
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Fresh-Corn-with-Wild-Rice-The-Pioneer-Woman-41396",
                        name: "Fresh Corn with Wild Rice",
                        ingredients: "butter, cayenne pepper, chicken broth, heavy cream, beaten eggs, wild rice, kosher salt, milk, corn kernels",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Fresh-Corn-with-Wild-Rice-The-Pioneer-Woman-41396-142252.s.jpg",
                        total_time_in_seconds: 4500,
                        source_display_name: "The Pioneer Woman",
                        source: "yummly")

    SourceRecipe.create!(recipe_ref: "Scalloped-Corn-TasteOfHome",
                        name: "Scalloped Corn",
                        ingredients:  "butter, corn, muffin mix, eggs, sour cream, corn kernels, white sugar",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Scalloped-Corn-Allrecipes-64415.s.png",
                        total_time_in_seconds: 3000,
                        source_display_name: "Taste of Home",
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Creamed-corn-with-chives-and-chiles-306076",
                        name: "Creamed Corn with Chives and Chiles",
                        ingredients: "chives, chile pepper, cheddar cheese, sea salt, cayenne pepper, heavy cream, rosemary, chicken stock, garlic cloves, 
                              red bell pepper, unsalted butter, lemon, cream cheese, scallions, ground black pepper, spanish onion, corn kernels, thyme leaves",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Creamed-corn-with-chives-and-chiles-306076-269406.s.jpg",
                        total_time_in_seconds: 3300,
                        source_display_name: "Food Republic",   
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Southwestern-artichoke-dip-with-sweet-corn-and-cayenne-310235",
                        name: "Southwestern Artichoke Dip with Sweet Corn and Cayenne",
                        ingredients: "mayonnaise, cayenne pepper, paprika, artichoke hearts, parmesan cheese, salt, corn kernels",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Southwestern-artichoke-dip-with-sweet-corn-and-cayenne-310235-274688.s.jpg",
                        total_time_in_seconds: 3000,
                        source_display_name: "Big Girls Small Kitchen" ,               
                        source: "yummly")

   SourceRecipe.create!(recipe_ref: "Bacon-Wrapped-Corn-Martha-Stewart-197182",
                        name: "Bacon-Wrapped Corn",
                        ingredients: "bacon, coarse salt, cayenne pepper, corn",
                        small_image_url: "http://yummly-recipeimages-compressed.s3.amazonaws.com/Bacon-Wrapped-Corn-Martha-Stewart-197182-112683.s.png",
                        total_time_in_seconds: 1500,
                        source_display_name: "Martha Stewart",
                        source: "yummly")
end

def make_platters
  users = User.all(limit: 6)
  source_recipes = SourceRecipe.all(limit: 5)
  40.times do |n|
    name = "#{Faker::Name.first_name}'s favorite platter"
    users.each do |user| 
      platter = user.platters.create!(name: name) 
      source_recipes.each do |source_recipe|
        platter.selections.create!(source_recipe_id: source_recipe.id)
      end
    end
  end
end


def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end