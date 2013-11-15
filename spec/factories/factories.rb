FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password  "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
  end
  
  factory :recipe do
    name "Secret Sauce"
    instructions "Abraca dabra"
    user
  end
  
  factory :platter do
    name "My Platter"
    user
  end
  
  factory :source_recipe do
    recipe_ref "Bacon-Wrapped-Corn-Martha-Stewart-197182"
    name "Bacon-Wrapped Corn"
    ingredients "bacon, coarse salt, cayenne pepper, corn"
    small_image_url "http://yummly-recipeimages-compressed.s3.amazonaws.com/Bacon-Wrapped-Corn-Martha-Stewart-197182-112683.s.png"
    total_time_in_seconds 1500
    source_display_name "Martha Stewart"
    source ENV["SOURCE_YUMMLY"]
  end
  
  factory :selection do
    platter
    source_recipe
  end
  
  factory :interest do
    platter
    user
  end
end
