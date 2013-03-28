require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
       before { sign_up_user }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.display_name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
        it { should have_link('Sign out') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link "Sign in" }
        end
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before { edit_user user }

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.display_name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let!(:story1) { FactoryGirl.create(:story, creator: user, owner: user, content: "Foo") }
    let!(:story2) { FactoryGirl.create(:story, creator: user, owner: user, content: "Bar") }
    let!(:story3) { FactoryGirl.create(:story, creator: user, owner: other_user, content: "Irrelevent") }
    before { visit user_path(user) }
  
    it { should have_selector('h1',    text: user.display_name) }
    it { should have_selector('title', text: user.display_name) }
    
    describe "stories" do
      it { should have_content(story1.content) }
      it { should have_content(story2.content) }
      it { should_not have_content(story3.content) }
      it { should have_content(user.own_stories.count) }
    end
  end
  
  describe "index" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.display_name)
        end
      end
      
      describe "delete links" do
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
  
  describe "senders/receivers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.receive!(other_user) }

    describe "senders" do
      before do
        sign_in user
        visit senders_user_path(user)
      end

      it { should have_selector('title', text: 'Senders') }
      it { should have_selector('h3', text: 'Senders') }
      it { should have_link(other_user.display_name, href: user_path(other_user)) }
    end

    describe "receivers" do
      before do
        sign_in other_user
        visit receivers_user_path(other_user)
      end

      it { should have_selector('title', text: 'Receivers') }
      it { should have_selector('h3', text: 'Receivers') }
      it { should have_link(user.display_name, href: user_path(user)) }
    end
  end
end