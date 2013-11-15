require 'spec_helper'

describe Platter do
  let(:platter_owner) { FactoryGirl.create(:user) }
  before do
    @platter = platter_owner.platters.build(name: "New Platter")
  end
  subject { @platter }
  
  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:last_platter_activity_at) }
  its(:user) { should eq platter_owner }
  it { should respond_to(:selections) }
  it { should respond_to(:interests) }
  
  it { should be_valid }

  describe "when user_id is not present" do
    before { @platter.user_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @platter.name = nil }
    it { should_not be_valid }
  end
  describe "with name that is too long" do
    before { @platter.name = "a" * 51 }
    it { should_not be_valid }
  end
  # describe "when last_platter_activity_at is not present" do
  #   before { @platter.last_platter_activity_at = nil }
  #   it { should_not be_valid }
  # end
  
  
  describe "selection associations" do
    let!(:source_recipe_1) { FactoryGirl.create(:source_recipe) }
    let!(:source_recipe_2) { FactoryGirl.create(:source_recipe, recipe_ref: "Beans-1234", name: "Black Beans") }
    before do
      @platter.save
      source_recipe_1.save
      source_recipe_2.save
    end
    let!(:older_selection) { FactoryGirl.create(:selection, platter: @platter, source_recipe: source_recipe_1) }
    let!(:newer_selection) { FactoryGirl.create(:selection, platter: @platter, source_recipe: source_recipe_2) }
    
    it "should destroy associated selections" do
      selections = @platter.selections.to_a
      @platter.destroy
      expect(selections).not_to be_empty
      selections.each do |selection|
        expect(Selection.where(id: selection.id)).to be_empty
      end
    end
    
    # describe "should not allow duplicate selections (i.e recipes)" do
    #   let(:selection2) { FactoryGirl.create(:selection, platter: @platter, source_recipe: source_recipe_1) }
    #   before do
    #     # dup_selection = selection.dup
    #     @platter.save
    #   end
    #   it {should_not be_valid}
    # end

  end
  
  describe "interest associations" do

    let(:platter_follower1) { FactoryGirl.create(:user) }
    let(:interest1) { platter_follower1.interests.build(platter_id: @platter.id) }

    let(:platter_follower2) { FactoryGirl.create(:user) }
    let(:interest2) { platter_follower2.interests.build(platter_id: @platter.id) }
    
    before do
      platter_owner.save
      @platter.save
      platter_follower1.save
      platter_follower2.save
      interest1.save
      interest2.save
    end
    
    it "should destroy associated interests" do
      interests = @platter.interests.to_a
      @platter.destroy
      expect(interests).not_to be_empty
      interests.each do |interest|
        expect(Interest.where(id: interest.id)).to be_empty
      end
    end
  end
   
end