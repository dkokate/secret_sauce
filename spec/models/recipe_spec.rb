require 'spec_helper'

describe Recipe do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @recipie = Recipe.new(name: "Secret Sauce", instructions: "Lorem ipsum", total_calories: 10, user_id: user.id)
  end
  
  it { should respond_to(:name) }
  it { should respond_to(:instructions) }
  it { should respond_to(:total_calories) }
  it { should respond_to(:user_id) }
end
