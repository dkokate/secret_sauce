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
      before do 
        FactoryGirl.create(:recipe, name: "Secret-Sauce 1", instructions: "Lorem ipsum", user: user)
        FactoryGirl.create(:recipe, name: "Secret-Sauce 2", instructions: "Dolor sit amet", user: user)
        sign_in user
        visit root_path
      end
      
      it "should render the list of user's recipes" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.name)
        end
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }  
      end
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
