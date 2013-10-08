require 'spec_helper'

describe "Yummly Recipe Pages" do
  subject { page }
  
  describe "Search Result Page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user 
      visit root_path
      fill_in "containing", with: "bean"
      click_button "Search"
    end  
    it {should have_title(full_title('Secret recipes'))}
    it { should have_link('Add to Platter') }
  end
end
