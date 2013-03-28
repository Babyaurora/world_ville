# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Relationship do
  let(:sender) { FactoryGirl.create(:user) }
  let(:receiver) { FactoryGirl.create(:user) }
  let(:relationship) { receiver.relationships.build(sender_id: sender.id) }

  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to receiver_id" do
      expect do
        Relationship.new(receiver_id: receiver.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when sender id is not present" do
    before { relationship.sender_id = nil }
    it { should_not be_valid }
  end

  describe "when receiver id is not present" do
    before { relationship.receiver_id = nil }
    it { should_not be_valid }
  end
  
  describe "relationship" do
    it { should respond_to(:sender) }
    it { should respond_to(:receiver) }
    its(:sender) { should == sender }
    its(:receiver) { should == receiver }
  end
end
