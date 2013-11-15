require 'spec_helper'

describe Interest do
  let(:platter_owner) { FactoryGirl.create(:user) }
  let!(:platter) { FactoryGirl.create(:platter, user: platter_owner)}
  
  let(:platter_follower) { FactoryGirl.create(:user) }
  
  let(:interest) { platter_follower.interests.build(platter_id: platter.id) }
  
  subject { interest }

  it { should be_valid }
  
end
