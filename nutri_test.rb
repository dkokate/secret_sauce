y = YummlyRecipeStore.new.get_recipe("Crispy-roasted-chickpeas-_garbanzo-beans_-308444")
y.nutritionEstimates.each do |nutri|
  case nutri["attribute"]
  when "ENERC_KCAL"
    puts "#{nutri['description']} : #{nutri['value']} #{nutri['unit']['abbreviation']}"
  else
    puts "#{nutri["attribute"]} #{nutri['description']} : #{nutri['value']} #{nutri['unit']['abbreviation']}"
  end
end
