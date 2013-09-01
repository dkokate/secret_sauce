require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it {should have_selector('h1', text: 'Sign in')} 
    it {should have_title(full_title('Sign in'))}
    
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
      before do
        fill_in "session_email", with: user.email.upcase 
        fill_in "session_password", with: user.password
        click_button "Sign in"
      end
      
      # pending(": valid info example not ready")
      it { should have_title(user.name) }
      it { should have_link('Recipes',  '#') }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',   href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by sign out" do 
        # pending(": signout example not ready")
        # before {click_link 'Sign out'}
        # before { all(:xpath, '//a[text()="Sign out"]').first.click }
        # it { should have_link('Sign in')}
      end
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
