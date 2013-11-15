require 'spec_helper'

describe SourceRecipe do
  before do
    @source_recipe = SourceRecipe.new(recipe_ref:   "Mexican-corn-on-the-cob-306886",
                         name:  "Mexican corn on the cob",
                         ingredients:         "butter, mayonnaise, corn, lime, cheese, cayenne",
                         small_image_url:       "http://yummly-recipeimages-compressed.s3.amazonaws.com/Mexican-corn-on-the-cob-306886-270609.s.jpg",
                         total_time_in_seconds:  2100,
                         source_display_name:   "Homesick Texan",
                         source: ENV["SOURCE_YUMMLY"])
  end
  subject { @source_recipe }
  
  it { should respond_to(:source) } 
  it { should respond_to(:recipe_ref) }
  it { should respond_to(:name) }
  it { should respond_to(:ingredients) }
  it { should respond_to(:total_time_in_seconds) }
  it { should respond_to(:small_image_url) }
  it { should respond_to(:source_display_name) }
  it { should respond_to(:selections) }
  
  it { should be_valid }
  
  describe "selection associations" do
    
    before { @source_recipe.save }
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:platter1) { FactoryGirl.create(:platter, user: user1)}
    let!(:platter1_selection) { FactoryGirl.create(:selection, platter: platter1, source_recipe: @source_recipe) }
    
    let!(:platter2) { FactoryGirl.create(:platter, user: user1)}
    let!(:platter2_selection) { FactoryGirl.create(:selection, platter: platter2, source_recipe: @source_recipe) }
    
    before do
      platter1.save
      platter1_selection.save
      platter2.save
      platter2_selection.save
    end
    
    it "should destroy associated selections" do
      selections = @source_recipe.selections.to_a
      @source_recipe.destroy
      expect(selections).not_to be_empty
      selections.each do |selection|
        expect(Selection.where(id: selection.id)).to be_empty
      end
    end
  end
  
end
