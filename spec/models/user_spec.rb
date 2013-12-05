require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")}
  # before { @user = User.new(name: "Example User", email: "user@example.com")}
  
  subject {@user}
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation )}
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:recipes) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:password_reset_token) }
  it { should respond_to(:password_reset_sent_at) }
  
  it { should respond_to(:platters) }
  it { should respond_to(:interests) }
  it { should respond_to(:platter_feed) }
  
  it {should be_valid}
  it {should_not be_admin}
  
  describe "with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    
    it { should be_admin}
  end
  
  describe "when name is not present" do
    before { @user.name = " "}
    it { should_not be_valid}
  end
  
  describe "when email is not present" do
    before { @user.email = " "} 
    it { should_not be_valid}
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 } 
    it { should_not be_valid}
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                           foo@bar_baz.com foo@bar+baz.com ]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end                  
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    
    it {should_not be_valid}
  end
  describe "when email address with different case is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it {should_not be_valid}
  end
  
  describe "when password is not present" do
     before {@user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")}
     it {should_not be_valid}
  end
  
  describe "when passowrd doesn't match confirmation" do
    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end
  
  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a" * 5}
    it {should be_invalid}
  end
  
  describe "return value of autheticate" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}
    
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) {found_user.authenticate("invalid")}
      
      it {should_not eq user_for_invalid_password}
      specify {expect(user_for_invalid_password).to be_false}
    end
  end
  
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end
  
  describe "recipe associations" do
    before { @user.save }
    let!(:older_recipe) { FactoryGirl.create(:recipe, user: @user, created_at: 1.day.ago) }
    let!(:newer_recipe) { FactoryGirl.create(:recipe, user: @user, created_at: 1.hour.ago) }

    it "should have the right recipes in the right order" do
      expect(@user.recipes.to_a).to eq [newer_recipe, older_recipe]
    end
    
    it "should destroy associated recipes" do
      recipes = @user.recipes.to_a
      @user.destroy
      expect(recipes).not_to be_empty
      recipes.each do |recipe|
        expect { Recipe.find(recipe) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe "status" do
      let(:unfollowed_recipe) { FactoryGirl.create(:recipe, user: FactoryGirl.create(:user)) }
      let(:followed_user) { FactoryGirl.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.recipes.create!(name: "Secret Sauce", instructions: "Lorem ipsum", total_calories: 10) }
      end
      
      its(:feed) { should include(newer_recipe) }
      its(:feed) { should include(older_recipe) }
      its(:feed) { should_not include(unfollowed_recipe) }
      its(:feed) do
        followed_user.recipes.each do |recipe|
          should include(recipe)
        end
      end
    end
  end
  
  describe "relationship associations" do
    it "should destroy associated relationships" do
        pending(": destroy relationship associations example not ready")
    end
  end
  
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }
    
    describe "followed_users" do
      subject { other_user}
      its(:followers) { should include(@user) }
    end
    
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
  
  describe "platter associations" do
    before { @user.save }
    let!(:older_platter) { FactoryGirl.create(:platter, user: @user, created_at: 1.day.ago) }
    let!(:newer_platter) { FactoryGirl.create(:platter, user: @user, created_at: 1.hour.ago) }

    # Platters should shown in descending order of last_platter_activity_at
    # it "should have the right platters in the right order" do
    #   expect(@user.platters.to_a).to eq [newer_platter, older_platter]
    # end
    
    it "should destroy associated platters" do
      platters = @user.platters.to_a # to_a is important
      # without to_a, destroying the user would destroy the list in the platters variable
      @user.destroy
      expect(platters).not_to be_empty # safety check in case the 'to_a' gets accidentally deleted
      platters.each do |platter|
        expect { Platter.find(platter) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "interest associations" do
    before { @user.save }
    let!(:platter_owner) { FactoryGirl.create(:user) }
    let!(:platter1) { FactoryGirl.create(:platter, user: platter_owner) }
    let!(:platter2) { FactoryGirl.create(:platter, user: platter_owner) }
    
    let!(:source_recipe_1) { FactoryGirl.create(:source_recipe) }
    let!(:source_recipe_2) { FactoryGirl.create(:source_recipe, recipe_ref: "Beans-1234", name: "Black Beans") }
    
    let!(:older_selection) { FactoryGirl.create(:selection, platter: platter1, source_recipe: source_recipe_1, created_at: 1.day.ago) }
    let!(:latest_selection) { FactoryGirl.create(:selection, platter: platter1, source_recipe: source_recipe_2, created_at: 1.minute.ago) }
    let!(:newer_selection) { FactoryGirl.create(:selection, platter: platter2, source_recipe: source_recipe_2, created_at: 1.hour.ago) }
    
    
    let!(:interest1) { FactoryGirl.create(:interest, platter: platter1, user: @user) }
    let!(:interest2) { FactoryGirl.create(:interest, platter: platter2, user: @user) }
    
    
    let!(:user_platter) { FactoryGirl.create(:platter, user: @user, created_at: 2.hours.ago) }

    # it "should have the right platters in the right order" do
    #   expect(@user.platter_feed.to_a).to eq [latest_selection.platter, user_platter, newer_selection.platter] 
    #   # 'created_at date' of latest_selection of platter1 overides 'created_at date' of older_selection 
    # end
    
    it "should have the right platters in the right order" do
        pending(": example not ready")
    end
    
    it "should destroy associated interests" do
      interests = @user.interests.to_a
      @user.destroy
      expect(interests).not_to be_empty
      interests.each do |interest|
        expect { Interest.find(interest) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe "status" do
      let!(:unfollowed_platter) { FactoryGirl.create(:platter, user: platter_owner) }
      let(:followed_user) { FactoryGirl.create(:user) }
      # before do
      #   @user.follow_platter!(followed_user)
      #   3.times { followed_user.recipes.create!(name: "Secret Sauce", instructions: "Lorem ipsum", total_calories: 10) }
      # end
      
      its(:platter_feed) { should include(user_platter) }
      its(:platter_feed) { should include(interest1.platter) }
      its(:platter_feed) { should include(interest2.platter) }
      its(:platter_feed) { should_not include(unfollowed_platter) }
      # its(:feed) do
      #   followed_user.recipes.each do |recipe|
      #     should include(recipe)
      #   end
      # end
    end
    
  end

end
