require 'spec_helper'

describe "Recipe pages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "new recipe creation" do
    before { visit new_recipe_path }
    describe ": recipe creation page" do
      it {should have_title(full_title('New recipe'))}
    end
       
    describe "with invalid info" do
      it "should not create a recipe" do
        expect { click_button "Publish" }.not_to change(Recipe, :count)
      end
      describe "error messages" do
        before { click_button "Publish" }
        it { should have_content("can't be blank") }
      end
    end
    describe "with valid info" do
      before do
        fill_in 'recipe_name', with: "Secret Sauce" 
        fill_in 'recipe_instructions', with: "Instruction Line 1"
        fill_in 'recipe_total_calories', with: "50"
      end
      it "should create a recipe" do
        expect { click_button "Publish" }.to change(Recipe, :count).by(1)
      end
    end
  end
  
  describe "recipe edit" do
    let!(:user_recipe) { FactoryGirl.create(:recipe, user: user) }
    before do 
      visit edit_recipe_path(user_recipe)
    end
    
    describe ": edit page" do
        it {should have_selector('h1', text: 'Edit Recipe')}
        it {should have_title(full_title('Edit recipe'))}
        it {should have_button("Update & Publish")}
    end
    
    describe ": edit process" do
      describe "with invalid info" do
        before do
          fill_in 'recipe_name', with: " "
          fill_in 'recipe_instructions', with: " "
          click_button "Update & Publish"
        end
        it { should have_content("can't be blank")}
      end
      describe "with valid info" do
        let(:new_name) {"New Name"}
        let(:new_instructions) {"New instructions"}
          let(:new_total_calories) {20}
        before do
          fill_in "recipe_name", with: new_name
          fill_in "recipe_instructions", with: new_instructions
          fill_in "recipe_total_calories", with: new_total_calories
          click_button "Update & Publish"
        end
        it { should have_title(user_recipe.user.name)} 
        it { should have_selector('div.alert.alert-success') }
        it { should have_content("Recipe updated")}
        specify { expect(user_recipe.reload.name).to  eq new_name }
        specify { expect(user_recipe.reload.instructions).to  eq new_instructions }
        specify { expect(user_recipe.reload.total_calories).to  eq new_total_calories }
      end
    end
  end
  
  describe "show a recipe" do
    let(:recipe) { FactoryGirl.create(:recipe, user: user) }
    before do
      visit recipe_path(recipe)
    end
    it { should have_title(full_title('Recipe')) }
    it {should have_selector('h1', text: "#{recipe.name}") }
    
    describe "as recipe's publisher" do
      before do
         sign_in recipe.user
        visit recipe_path(recipe)
      end
      it { should have_link("Edit Recipe", edit_recipe_path(recipe)) }
      it { should have_link("Delete Recipe") }
      it "should delete the recipe" do
        expect { click_link "Delete Recipe" }.to change(Recipe, :count).by(-1)
      end
    end
    describe "as recipe's non-publisher" do
    let(:non_publisher) { FactoryGirl.create(:user) }
      before do
        sign_in non_publisher
        visit recipe_path(recipe)
      end
      it { should_not have_link("Edit Recipe", edit_recipe_path(recipe)) }
      it { should_not have_link("Delete Recipe") }
    end
  end

end
