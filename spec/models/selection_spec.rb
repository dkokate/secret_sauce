require 'spec_helper'

describe Selection do
  let(:user) { FactoryGirl.create(:user) }
  let!(:platter) { FactoryGirl.create(:platter, user: user) }
  let(:source_recipe) { FactoryGirl.create(:source_recipe) }
  before do
    @selection = platter.selections.build(source_recipe_id: source_recipe.id)
  end
  
  subject { @selection }
  
  it { should respond_to(:platter_id) }
  it { should respond_to(:platter) }
  its(:platter) { should eq platter }
  
  it { should respond_to(:source_recipe_id) }
  it { should respond_to(:source_recipe) }
  its(:source_recipe) { should eq source_recipe }
  
  it { should be_valid }
end
