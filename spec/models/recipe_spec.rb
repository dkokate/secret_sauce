require 'spec_helper'

describe Recipe do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @recipe = user.recipes.build(name: "Secret Sauce", instructions: "Lorem ipsum", total_calories: 10)
  end
  
  subject{ @recipe }
  
  it { should respond_to(:name) }
  it { should respond_to(:instructions) }
  it { should respond_to(:total_calories) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }
  
  describe "when user is not present" do
    before { @recipe.user_id = nil }
    it { should_not be_valid }
  end
  describe "when name is not present" do
    before { @recipe.name = nil }
    it { should_not be_valid }
  end
  describe "with name that is too long" do
    before { @recipe.name = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when instructions are not present" do
    before { @recipe.instructions = nil }
    it { should_not be_valid }
  end
end
