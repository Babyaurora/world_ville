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
  it { should respond_to(:original_story) }
  it { should respond_to(:reply_stories) }
  
  it { should be_valid }
  its(:user) { should == user1 }
  
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
