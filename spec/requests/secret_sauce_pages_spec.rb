require 'spec_helper'

describe "Secret Sauce pages" do
  subject {page}
  
  describe "Home page" do
    before { visit root_path}
    
    it {should have_content('Secret Sauce')}
    it {should have_title(full_title('')) }
      # save_and_open_page  
    it {should_not have_title("| Home")}  
  end
  
  describe "Help page" do
    before {visit help_path}
    
    it {should have_content('Help')}
    it {should have_title("Secret Sauce | Help")}
  end
  
  describe "About Us page" do
    before {visit about_path}
    
    it {should have_content('About Us')}
    it {should have_title(full_title("About Us"))}
  end
  
  describe "Contact page" do
    before {visit contact_path}
    
    it {should have_content('Contact')} 
    it {should have_title(full_title("Contact"))}
  end
end
