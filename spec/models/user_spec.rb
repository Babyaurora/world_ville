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
end
