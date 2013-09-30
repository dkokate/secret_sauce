require 'spec_helper'

describe "User pages" do
  subject {page}
  
  describe "index page" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in FactoryGirl.create(:user)
      visit users_path
    end
    it {should have_title('Gotu Chefs') }
    it {should have_selector('h1', text: 'The Gotu Chefs') }
    
    describe "pagination" do
      before(:all) { 30.times {FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }
      
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      it { should_not have_link('delete') }
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href:user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete', match: :first) }.to change(User, :count).by(-1)
        end
      end
    end

  end
  
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    let!(:r1) { FactoryGirl.create(:recipe, user: user, name: "Foo") }
    let!(:r2) { FactoryGirl.create(:recipe, user: user, name: "Bar") }
    
    before { visit user_path(user) }
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
    
    describe "recipes" do
      it {should have_content(r1.name) }
      it {should have_content(r2.name) }
      it {should have_content(user.recipes.count) }
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "following a user" do
        before { visit user_path(other_user) }
        
        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        
        it "should increment the other users followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
        
        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end
      
      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        
        it "should decrement the followed user count by 1" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end
        
        it "should decrement the other users followers count by 1" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end 
      end
    end
  end
  
  describe "signup page" do
    before {visit signup_path}
    it {should have_selector('h1', text: 'Sign up')} 
    # it {should have_content('Sign up')}
    it {should have_title(full_title('Sign up'))}
  end
  
  describe "signup process" do
    before { visit signup_path}
    let(:submit) {"Create my account"}
    
    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button submit}.not_to change(User, :count)
      end
      describe "after submission" do
        it {should have_title('Sign up')}
        describe " should show error messages" do
          pending(": submission example not ready")
          # it {should have_content('error')}
          # it { should have_selector('.help-inline') } # Needs to be tested properly
        end
      end
    end
    
    describe "valid information" do
      # pending(">> example not ready")
      before do
        fill_in "user_name", with: "Example User"
        fill_in "user_email", with: "user@example.com"
        fill_in "user_password", with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end
      it "should create a user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before {click_button submit}
        let(:user) { User.find_by(email: 'user@example.com')}

        # it {should have_title(user.name)}     # User Profile Page
        it {should have_title(full_title(''))}  # Home Page
        
        it {should have_selector('div.alert.alert-success', text: 'Enjoy')} 
        
        it { should have_link('Recipes',  '#') }
        it { should have_link("Gotu's",  href: users_path) }
        it { should have_link('Profile',     href: user_path(user)) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
        it { should have_link('Sign out',   href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }
      end
    end
    
    describe "for an already signed in user" do
      describe "attempting to visit signup_path" do
        let(:user) { FactoryGirl.create(:user) }
        before do 
          sign_in user 
          visit signup_path
        end
        it { should have_selector('h3', text: "Recipe Feed") } # Home page for signed user shows Recipe Feed
        it { should_not have_title("Sign up") }
      end
      describe "attempting to submit a User#create action" do
        let(:params) do
          { user: { name: "zx", email: "z@x.com", password: "foobar", password_confirmation: "foobar" } }
        end
        let(:some_user) { FactoryGirl.create(:user)}
        before do 
          sign_in some_user, no_capybara: true
          post users_path, params
        end  
        specify { expect(response).to redirect_to(root_url) }
      end
    end

  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    before do 
      sign_in(user)
      visit edit_user_path(user) 
    end
    
    describe ": edit page" do
      it {should have_selector('h1', text: 'Update your profile')}
      it {should have_title(full_title('Edit profile'))}
      it { should have_link('change', href: 'http://gravatar.com/emails') }
      
      describe "forbidden attributes" do
        before do 
          sign_in user, no_capybara: true 
          visit edit_user_path(user) 
        end
        let(:params) do
          { user: { admin: true, password: user.password,
                    password_confirmation: user.password } }
        end
        before { patch user_path(user), params }
        specify { expect(user.reload).not_to be_admin }
      end
    end
    
    describe ": edit process" do
      describe "with invalid info" do
        before { click_button "Save changes" }

        it { should have_title('Edit profile') }
        pending(">> example for checking errors is not ready")
        # it { should have_selector('div span.help-inline') } # Needs to be tested properly
      end
      describe "with valid info" do
        let(:new_name) {"New Name"}
        let(:new_email) {"new@example.com"}
        before do
          fill_in "user_name", with: new_name
          fill_in "user_email", with: new_email
          fill_in "user_password", with: user.password
          fill_in "user_password_confirmation", with: user.password
          click_button "Save changes"
        end
        it { should have_title(new_name)}
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end
    end
  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }
    
    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      it { should have_title('Following') }
      it { should have_selector('h3', text: "Following") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end
    
    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      it { should have_title('Followers') }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

end
