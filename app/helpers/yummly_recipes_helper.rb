module YummlyRecipesHelper
  def directions_available_for?(site_address)
    case site_address
    when "http://www.food.com" then @selector = '.txt'; return true
    when "http://www.marthastewart.com" then @selector = '.step-data'; return true
    when "http://www.foodrepublic.com" then @selector = '.odd li'; return true # Remove selections 'Popular', 'Recommended'
    when "http://www.myrecipes.com" then @selector = '.recipeDetails ol li'; return true
    when "http://instantparty.com" then @selector = '.yummly-prep-steps li'; return true
    when "http://www.yummly.com/unilever" then @selector = '.yummly-prep-steps li'; return true
    when "http://www.foodnetwork.com" then @selector = '.fn_instructions p'; return true 
    when "http://www.allrecipes.com" then @selector = '.break'; return true
    when "http://theshiksa.com" then @selector = '.instruction'; return true
    when "http://thepioneerwoman.com/cooking" then @selector = '.recipe-box p'; return true
    when "http://naturallyella.com" then @selector = '.instruction'; return true
    when "http://www.epicurious.com" then @selector = '.instruction'; return true
    when "http://camillestyles.com" then @selector = '.entry-content ol li'; return true
    when "http://www.onceuponachef.com/" then @selector = '.instruction'; return true #  <<<< Check this
    when "http://www.seriouseats.com/recipes/" then @selector = '.procedure-text p'; return true
    when "http://savourthesensesblog.com" then @selector = '.instruction'; return true
    when "http://www.cinnamonspiceandeverythingnice.com/" then @selector = '.instruction'; return true
    when "http://www.tasteofhome.com" then @selector = '.rd_directions .rd_name'; return true
    when "http://www.chow.com" then @selector = '#instructions li'; return true
    when "http://iadorefood.com" then @selector = '.instructions li'; return true
    when "http://simplyrecipes.com" then @selector = '#recipe-method div p'; return true # <<< Check for blank lines
    when "http://steamykitchen.com" then @selector = '.directions p'; return true
    # when "http://www.kalynskitchen.com/" then @selector = '.entry-content div'; return true 
    # <<< Remove 'Printer Friendly Recipe' line & blanks, Also the initial blah blah blah
   
   
      
    when "http://www.howsweeteats.com" then return false  
    when "http://smittenkitchen.com" then return false  
    # when "http://www.kalynskitchen.com/" then return false
    when "http://www.thekitchn.com/categories/recipe" then return false
    when "http://www.people.com" then return false
    when "http://www.101cookbooks.com/" then return false
    when "http://picky-palate.com" then return false
    when "http://www.davidlebovitz.com/" then return false
    when "http://food52.com/blog" then return false
    when "http://www.biggirlssmallkitchen.com" then return false
    when "http://homesicktexan.blogspot.com/" then return false
     
            
    else
      return false
    end     
  end
end
