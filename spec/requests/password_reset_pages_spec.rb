require 'spec_helper'

describe "Password reset request and Reset password" do
  
  describe "Password reset request" do
    subject { page }
  
    describe "password reset request page" do
      before { visit password_reset_path }
    
      it {should have_selector('h1', text: 'Password Reset request') } 
      it {should have_title(full_title('Password reset request')) }
    end
  
    describe "password reset request process" do
      before { visit password_reset_path } 
      describe "with invalid info" do
        before { click_button "Reset password" }
    
      it { should have_title('Password reset request') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
        # similar test as in user sign up page
        pending(": invalid email address check example not ready")
      end
    
      describe "with incorrect email submitted" do
        let(:user) {FactoryGirl.create(:user)}
        before do 
          fill_in "password_reset_email", with: "nobody@example.com"
          click_button "Reset password" 
        end
        specify { expect(current_path).to eq(password_resets_path || password_reset_path) }
        it { should have_title('Password reset request') }
        it "should not generate an email" do
          last_email.should be_nil
        end
      end
    
      describe "with valid info" do
        let(:user) {FactoryGirl.create(:user)}
        before do 
          fill_in "password_reset_email", with: user.email
          click_button "Reset password" 
        end
        it {should have_selector('div.alert.alert-notice', text: 'Password reset instructions have been emailed to you')}
        it "should render the home page" do
          expect(page).to have_selector('h1', text: 'Secret Sauce') 
        end
        it "should generate an email" do
          last_email.to.should include(user.email)
        end
      end
 
    end
  end
  describe "Resetting the password" do
    
    subject { page }
    let(:user) { FactoryGirl.create(:user, :password_reset_token => "something", 
                    :password_reset_sent_at => 1.hour.ago) }
    before do 
      visit edit_password_reset_path(user.password_reset_token)
    end
    
    describe "Reset Password page" do
      it {should have_selector('h1', text: 'Reset Password')} 
      it {should have_title(full_title('Reset Password'))}
    end
    
    describe "Reset Password process" do
      describe "updates the user password when confirmation matches" do
        before do
          fill_in "user_password", with: "foobar"
          # click_button "Update Password"
          # it { should have_content("Password doesn't match confirmation") }
          fill_in "user_password_confirmation", with: "foobar"
          click_button "Update Password"
        end
        it { should have_content("Your password has been reset") }
      end
      
      describe "reports when password token has expired" do
        let(:user) { FactoryGirl.create(:user, :password_reset_token => "something", 
                      :password_reset_sent_at => 5.hour.ago) }
        before do
          visit edit_password_reset_path(user.password_reset_token)
          fill_in "user_password", with: "foobar"
          fill_in "user_password_confirmation", with: "foobar"
          click_button "Update Password"
        end
        it { should have_content("Password reset has expired") }
      end
      describe  "raises record not found when password token is invalid" do
        specify { expect { visit edit_password_reset_path("invalid") }.to raise_exception(ActiveRecord::RecordNotFound) }
      end
      
    end
  end
end
