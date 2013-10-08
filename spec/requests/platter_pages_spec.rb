require 'spec_helper'

describe "Platter pages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "new platter creation" do
    before { visit user_path(user) } # profile page
       
    describe "with invalid info" do
      it "should not create a platter" do
        expect { click_button "Create" }.not_to change(Platter, :count)
      end
      # describe "error messages" do
      #   before { click_button "Create" }
      #   it { should have_content("Please fill out this field") }
      # end
    end
    describe "with valid info" do
      before do
        fill_in 'platter_name', with: "New Platter" 
      end
      it "should create a platter" do
        expect { click_button "Create" }.to change(Platter, :count).by(1)
      end
    end
  end
  
  # describe "platter edit" do
  #   let!(:user_platter) { FactoryGirl.create(:platter, user: user) }
  #   before do 
  #     visit edit_platter_path(user_platter)
  #   end
  #   
  #   describe ": edit page" do
  #       it {should have_selector('h1', text: 'Edit Platter')}
  #       it {should have_title(full_title('Edit Platter'))}
  #       it {should have_button("Update")}
  #   end
  #   
  #   describe ": edit process" do
  #     describe "with invalid info" do
  #       before do
  #         fill_in 'platter_name', with: " "
  #         click_button "Update"
  #       end
  #       it { should have_content("can't be blank")}
  #     end
  #     describe "with valid info" do
  #       let(:new_name) {"New Name"}
  #       before do
  #         fill_in "platter_name", with: new_name
  #         click_button "Update"
  #       end
  #       it { should have_title(user_platter.name)} 
  #       it { should have_selector('div.alert.alert-success') }
  #       it { should have_content("Platter updated")}
  #       specify { expect(user_platter.reload.name).to  eq new_name }
  #     end
  #   end
  # end
  
  describe "show a platter" do
    let(:platter) { FactoryGirl.create(:platter, user: user) }
    let!(:source_recipe_1) { FactoryGirl.create(:source_recipe) }
    let!(:source_recipe_2) { FactoryGirl.create(:source_recipe, recipe_ref: "Beans-1234", name: "Black Beans") }
    let!(:selection1) { FactoryGirl.create(:selection, platter: platter, source_recipe: source_recipe_1) }
    let!(:selection2) { FactoryGirl.create(:selection, platter: platter, source_recipe: source_recipe_2) }
    before do
      visit platter_path(platter)
    end
    
    it { should have_title(full_title(platter.name)) }
    it {should have_selector('h1', text: "#{platter.name}") }
    
    describe "as platter's owner" do
      before do
         sign_in platter.user
        visit platter_path(platter)
      end
      # it { should have_link("Edit Platter", edit_platter_path(platter)) } <<<<<<<<<<<<
      it { should have_link("Delete Platter") }
      it "should delete the platter" do
        expect { click_link "Delete Platter" }.to change(Platter, :count).by(-1)
      end
    end
    describe "as platter's non-owner" do
    let(:non_owner) { FactoryGirl.create(:user) }
      before do
        sign_in non_owner
        visit platter_path(platter)
      end
      # it { should_not have_link("Edit Platter", edit_platter_path(platter)) }  <<<<<<<<<<<<
      it { should_not have_link("Delete Platter") }
    end
    
    describe "selections" do
      it { should have_content(selection1.source_recipe.name) }
      it { should have_content(selection2.source_recipe.name) }
      it { should have_content(platter.selections.count) }
    end
  end

end
