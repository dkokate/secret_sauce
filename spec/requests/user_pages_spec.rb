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
    before { visit user_path(user) }
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
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

        it {should have_title(user.name)}
        it {should have_selector('div.alert.alert-success', text: 'Enjoy')} 
        
        it { should have_title(user.name) }
        it { should have_link('Recipes',  '#') }
        it { should have_link("Gotu's",  href: users_path) }
        it { should have_link('Profile',     href: user_path(user)) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
        it { should have_link('Sign out',   href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }
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


end
