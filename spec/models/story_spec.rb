# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer          not null
#  to_user_id :integer          not null
#  reply_id   :integer
#  rating     :integer          default(0)
#  reply_num  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Story do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  before { @story = user1.stories.create(content: "Lorem ipsum", to_user_id: user2.id) }
  
  subject { @story }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:to_user_id) }
  it { should respond_to(:reply_id) }
  it { should respond_to(:rating) }
  it { should respond_to(:reply_num) }
  it { should respond_to(:user) }
  it { should respond_to(:owner_user) }
  it { should respond_to(:original_story) }
  it { should respond_to(:reply_stories) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Story.new(user_id: user1.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when user_id is not present" do
    before { @story.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when to_id is not present" do
    before { @story.to_user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @story.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @story.content = "a" * 1001 }
    it { should_not be_valid }
  end
  
  describe "user association" do
    its(:user) { should == user1 }
    its(:owner_user) { should == user2 }
  end
  
  describe "reply story" do
    before { @reply_story1 = user1.stories.create(content: "Lorem ipsum", to_user_id: user2.id, reply_id: @story.id) }
    its(:reply_stories) { should include(@reply_story1) }
    it { should == @reply_story1.original_story }
   
    describe "reply_num" do
      before { @story.reload }
      its(:reply_num) { should == 1 }
      
      describe "increase" do
        before do
          @reply_story2 = user1.stories.create(content: "Lorem ipsum", to_user_id: user2.id, reply_id: @story.id) 
          @story.reload
        end
        its(:reply_num) { should == 2 }
        
        describe "decrease" do
        before do
          @reply_story2.destroy
          @story.reload
        end
        its(:reply_num) { should == 1 }
      end
      end
    end
  end
end
