require 'spec_helper'

describe "Secret Sauce pages" do
  describe "Home page" do
    it "should have the content 'Secret Sauce'" do
      visit '/secret_sauce_pages/home'
      expect(page).to have_content('Secret Sauce')
    end
    
    it "should have the title 'Home'" do 
      visit '/secret_sauce_pages/home' 
      expect(page).to have_title("Secret Sauce | Home")
      # save_and_open_page
    end 
    
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/secret_sauce_pages/help'
      expect(page).to have_content('Help')
      # secret_sauce_pagesave_and_open_page
    end
    
    it "should have the title 'Help'" do 
      visit '/secret_sauce_pages/help' 
      expect(page).to have_title("Secret Sauce | Help")
    end
  end
  
  describe "About Us page" do
    it "should have the content 'About Us'" do
      visit '/secret_sauce_pages/about'
      expect(page).to have_content('About Us')
      # secret_sauce_pagesave_and_open_page
    end
    
    it "should have the title 'About Us'" do 
      visit '/secret_sauce_pages/about' 
      expect(page).to have_title("Secret Sauce | About Us")
    end
  end
end
