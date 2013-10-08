require 'spec_helper'

describe Platter do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @platter = user.platters.build(name: "New Platter", user_id: user.id)
  end
  subject { @platter }
  
  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should respond_to(:selections) }

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
   
end