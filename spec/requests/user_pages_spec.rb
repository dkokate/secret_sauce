require 'spec_helper'

describe "User pages" do
  subject {page}
  
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
  
  describe "signup" do
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
      end
    end
  end
end
