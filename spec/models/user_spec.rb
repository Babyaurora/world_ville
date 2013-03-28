# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  unique_id       :string(255)      not null
#  display_name    :string(255)      not null
#  email           :string(255)
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  user_type       :integer          not null
#  coins           :integer
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(display_name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar", user_type: 0) }
  subject { @user }
  
  it { should respond_to(:unique_id) }
  it { should respond_to(:display_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:session_token) }
  it { should respond_to(:user_type) }
  it { should respond_to(:admin) }
  it { should respond_to(:coins) }
  it { should respond_to(:create_stories) }
  it { should respond_to(:own_stories) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:senders) }
  it { should respond_to(:receiving?) }
  it { should respond_to(:receive!) }
  it { should respond_to(:unreceive!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:receivers) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
    
    it "should not allow access to unique id" do
      expect do
        User.new(unique_id: '')
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
    
    it "should not allow access to session token" do
      expect do
        User.new(session_token: '')
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  
  describe "display name" do
    describe "when display name is not present" do
      before { @user.display_name = " " }
      it { should_not be_valid }
    end
  
    describe "when display name is too long" do
      before { @user.display_name = "a" * 51 }
      it { should_not be_valid }
    end
    
    describe "when display name is not unique for person type" do
      before do 
        another_user = @user.dup 
        another_user.email = "user2@example.com"
        another_user.save
      end
      it { should be_valid }
    end
    
    describe "when display name is not unique for shop type" do
      before do 
        @user.user_type = 1
        another_user = @user.dup 
        another_user.email = "user2@example.com"
        another_user.save
      end
      it { should be_valid }
    end
    
    describe "when display name is not unique for community type" do
      before do
        @user.user_type = 2
        another_user = @user.dup
        another_user.email = "user2@example.com"
        another_user.save
      end
      it { should_not be_valid }
    end
  end
  
  describe "when user type is out of range" do
    before { @user.user_type = 3 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
      foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    describe 'with same case' do
      before { @user.dup.save }
      it { should_not be_valid }
    end
    
    describe "with different case" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it { should_not be_valid }
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "authentication" do
    describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_unique_id(@user.email) }
    
      describe "with valid password" do
        it { should == found_user.authenticate(@user.password) }
      end
    
      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }
    
        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
      end
    end
  end
  
  describe "session token" do
    before { @user.save }
    its(:session_token) { should_not be_blank }
  end
  
  describe "story associations" do
    before { @user.save }
    let!(:owner) { FactoryGirl.create(:user) }
    let!(:older_story) { FactoryGirl.create(:story, creator: @user, owner: owner, created_at: 1.day.ago) }
    let!(:newer_story) { FactoryGirl.create(:story, creator: @user, owner: owner, created_at: 1.hour.ago) }

    describe "user created stories should be in the right order" do
      its(:create_stories) { should == [newer_story, older_story] }
    end
    
    it "user owned stories should be in the right order" do
      owner.own_stories.should == [newer_story, older_story] 
    end
    
    describe "status" do
      let(:other_story) { FactoryGirl.create(:story) }
      let(:sender) { FactoryGirl.create(:user) }
      
      before do
        @user.receive!(sender)
        3.times { sender.create_stories.create!(content: "Lorem ipsum", owner_id: sender.id) }
      end

      its(:feed) { should include(newer_story) }
      its(:feed) { should include(older_story) }
      its(:feed) { should_not include(other_story) }
      its(:feed) do
        sender.own_stories.each do |story|
          should include(story)
        end
      end
    end
    
    describe "destroy" do
      let(:story_id1) { older_story.id }
      let(:story_id2) { newer_story.id }
      
      describe "creator" do
        before { @user.destroy }
       
        it "should not destroy associated stories" do
           Story.find_by_id(story_id1).should_not be_nil
           Story.find_by_id(story_id2).should_not be_nil
        end
      end
      
      describe "owner" do
        before { owner.destroy }
       
        it "should destroy associated stories" do
          Story.find_by_id(story_id1).should be_nil
          Story.find_by_id(story_id2).should be_nil
        end
      end
    end
  end
  
  describe "receiving" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @user.save
      @user.receive!(other_user)
    end

    it { should be_receiving(other_user) }
    its(:senders) { should include(other_user) }
    
    it "should be other user's receiver" do
      other_user.receivers.should include(@user)
    end
    
    describe "and unreceiving" do
      before { @user.unreceive!(other_user) }

      it { should_not be_receiving(other_user) }
      its(:senders) { should_not include(other_user) }
    end
  end
end
