require 'spec_helper'

describe "Secret Sauce pages" do
  subject {page}
  
  shared_examples_for "all Secret Sauce static pages" do
    it {should have_selector('h1', text: heading)} 
    it {should have_title(full_title(page_title))}
    # -------------- Test for links to common pages ------------------ #
    it "should have the right links on the layout" do
      click_link "Home"
      expect(page).to have_title(full_title(''))

      click_link "Help"
      expect(page).to have_title(full_title('Help'))

      click_link "About"
      expect(page).to have_title(full_title('About Us'))

      click_link "Contact"
      expect(page).to have_title(full_title('Contact'))

      # click_link "News"
      # expect(page).to have_title(full_title('About Us'))

      # click_link "Secret Sauce"
      # expect(page).to have_title(full_title('Secret Sauce'))
    end
  end
  
  describe "Home page" do
    before { visit root_path}
    let(:heading) {'Secret Sauce'}
    let(:page_title) {''}
    
    it_should_behave_like "all Secret Sauce static pages"
    it {should_not have_title("| Home")} 
    
    describe "when user is not signed in" do
      it { should have_link('Sign Up now!', href: signup_path) }
      it { should have_link('Sign in', href: signin_path) }
    end
    
    describe "when user is signed in" do
      let(:user) { FactoryGirl.create(:user)}
      before { sign_in user }
      
      it { should_not have_link('Sign Up now!') }
      it { should_not have_link('Sign in') }
      it { should have_link('Platters', href: user_path(user)) }
      it { should have_link("Gotu's",  href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',   href: signout_path) }
    end
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user)}      
      let(:platter) { FactoryGirl.create(:platter, user: user) }
      let!(:source_recipe_1) { FactoryGirl.create(:source_recipe) }
      let!(:source_recipe_2) { FactoryGirl.create(:source_recipe, recipe_ref: "Beans-1234", name: "Black Beans") }
      let!(:selection1) { FactoryGirl.create(:selection, platter: platter, source_recipe: source_recipe_1) }
      let!(:selection2) { FactoryGirl.create(:selection, platter: platter, source_recipe: source_recipe_2) }
      
      before do 
        FactoryGirl.create(:recipe, name: "Secret-Sauce 1", instructions: "Lorem ipsum", user: user)
        FactoryGirl.create(:recipe, name: "Secret-Sauce 2", instructions: "Dolor sit amet", user: user)
        sign_in user
        visit root_path
      end
      
      # 
      # it "should render the list of user's recipes" do
      #   user.feed.each do |item|
      #     expect(page).to have_selector("li##{item.id}", text: item.name)
      #   end
      # end
      
      it "should render the list of user's platter feed" do
        user.platter_feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.name)
        end
      end
      
      describe "platter stats" do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:other_user_platter) { FactoryGirl.create(:platter, user: other_user) }
        before do
          other_user.follow_platter!(platter)
        end
        describe "followed counts" do
          before do
            visit root_path
          end
          it { should have_link("0 following", href: following_platter_path(user)) }
          it { should have_link("1 followed", href: followed_platter_path(user)) }
        end
        describe "following counts" do
          before do
            sign_in other_user
            visit root_path
          end
          it { should have_link("1 following", href: following_platter_path(other_user)) }
          it { should have_link("0 followed", href: followed_platter_path(other_user)) }
        end  
      end
    end 
    it "should render list of 'interesting' platters" do
    end
  end
  
  describe "Help page" do
    before {visit help_path}
    let(:heading) {'Help'}
    let(:page_title) {'Help'}
    
    it_should_behave_like "all Secret Sauce static pages"
    
    # should have_selector('h1', text: 'Help')} # it {should have_title("Secret Sauce | Help")}
  end
  
  describe "About Us page" do
    before {visit about_path}
    let(:heading) {'About Us'}
    let(:page_title) {'About Us'}
    
    it_should_behave_like "all Secret Sauce static pages"
    
    # it {should have_selector('h1', text: 'CAbout Us')} # it {should have_title(full_title("About Us"))}
  end
  
  describe "Contact page" do
    before {visit contact_path}
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}
    
    it_should_behave_like "all Secret Sauce static pages"
    
    # it {should have_selector('h1', text: 'Contact')} # it {should have_title(full_title("Contact"))}
  end
  
  describe "Sign in page" do
    before {visit signin_path}
    let(:heading) {'Sign in'}
    let(:page_title) {'Sign in'}
    
    it_should_behave_like "all Secret Sauce static pages"
  end
  
end
