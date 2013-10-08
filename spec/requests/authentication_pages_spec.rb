require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it {should have_selector('h1', text: 'Sign in')} 
    it {should have_title(full_title('Sign in'))}
    it { should have_link("forgot password?", password_reset_path ) } # href: users_path
  end
  
  describe "signin process" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign in" }
      
      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      # Since render 'new' does not count as a new request the flash error message persists after user navigates to a new page 
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information; after signing in" do
      let(:user) {FactoryGirl.create(:user)}
      before { sign_in user } 
      # sign_in helper in spec/support/utilities.rb (replaces following code)
      # before do
      #  fill_in "session_email", with: user.email.upcase 
      #  fill_in "session_password", with: user.password
      #  click_button "Sign in"
      # end
      
      # pending(": valid info example not ready")
      # it { should have_title(user.name) }   # User Profile Page
      it {should have_title(full_title(''))}  # Home Page
      it { should have_link('Platters',  href: user_path(user)) }
      it { should have_link("Gotu's",  href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',   href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by sign out" do 
        # pending(": signout example not ready")
        # before {click_link 'Sign out'}
        # it { should have_link('Sign in')}
        describe ": sign out in Accounts drop down menu" do
          before { all(:xpath, '//a[text()="Sign out"]').first.click }
          it { should have_link('Sign in')}
        end
        
        describe ": sign out in Main Menu" do
          before { all(:xpath, '//a[text()="Sign out"]')[1].click } # Check the next 'Sign out' link
          it { should have_link('Sign in')}
        end
      end
    end 
  end
  
  describe "authorization" do
    describe "for non-signed in users" do
      let(:user) { FactoryGirl.create(:user)}
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user # sign_in helper in spec/support/utilities.rb 
        end

        describe "after signing in" do
          it "should render the desired protected page" do 
            expect(page).to have_title('Edit profile')
          end
        end
      end
      
      describe "in Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user)}
          it { should have_title('Sign in')}
        end
        
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "visiting the index page" do
          before { visit users_path}
          it { should have_title('Sign in')}
        end
        
        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end
        
        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end
      
      end
      
      describe "in Recipes controller" do
        describe "submitting to the new action" do
          before { get new_recipe_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submitting to the create action" do
          before { post recipes_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submiiting to the update action" do
          let(:recipe) { FactoryGirl.create(:recipe) }
          before do 
            recipe.name = "New Name"
            patch recipe_path(recipe) 
          end
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submiiting to the destroy action" do
          before { delete recipe_path(FactoryGirl.create(:recipe)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      
      describe "in Platters controller" do
        describe "submitting to the create action" do
          before { post platters_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submiiting to the update action" do
          let(:platter) { FactoryGirl.create(:platter) }
          before do 
            platter.name = "New Platter"
            patch platter_path(platter) 
          end
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submiiting to the destroy action" do
          before { delete platter_path(FactoryGirl.create(:platter)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      describe "in Selections controller" do
        describe "submitting to the create action" do
          before { post selections_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submiiting to the destroy action" do
          before { delete selection_path(FactoryGirl.create(:selection)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

    end
    describe "for wrong signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }
      
      describe "visiting Users#edit page" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit profile')) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a PATCH request to Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
      
      describe "visiting Recipe#edit page" do
        
        let!(:correct_user_recipe) { FactoryGirl.create(:recipe, user: user) }
        let!(:wrong_user_recipe) { FactoryGirl.create(:recipe, user: wrong_user) }
        before do
          sign_in user 
          visit edit_recipe_path(wrong_user_recipe)
        end
        it {should_not have_title(full_title('Edit recipe'))}
        it {should_not have_selector('h1', text: 'Edit Recipe')}
        it { should have_selector('h3', text: "Recipe Feed") } # Home page for signed user shows Recipe Feed
        # it {should have_selector('h1', text: 'Secret Sauce')}   # Chack for root url
        specify { expect(current_path).to eq(root_path) }
        # specify { expect(response).to redirect_to(root_url) } --- Doesn't work
      end
      
      describe "submitting a DESTROY request to Recipe#destroy action" do
        
        let!(:correct_user_recipe) { FactoryGirl.create(:recipe, user: user) }
        let!(:some_user_recipe) { FactoryGirl.create(:recipe, user: user) }
        before do
          sign_in correct_user_recipe.user, no_capybara: true 
          delete recipe_path(some_user_recipe)
        end
          specify { expect(response).to redirect_to(root_path) }
      end
    end
    
    describe "for non-admin signed user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin_user) { FactoryGirl.create(:user) }
      before { sign_in non_admin_user, no_capybara: true }
      
      describe "submitting a DELETE request to Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
