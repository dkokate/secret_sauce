require 'spec_helper'

describe "Selection pages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:platter) { FactoryGirl.create(:platter, user: user) }
  before { sign_in user }
  
  describe "selection creation" do
    before { visit }
  end
end
