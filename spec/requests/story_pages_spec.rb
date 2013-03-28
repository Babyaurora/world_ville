require 'spec_helper'

describe "StoryPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "story creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a story" do
        expect { click_button "Post" }.not_to change(Story, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'story_content', with: "Lorem ipsum" }
      it "should create a story" do
        expect { click_button "Post" }.to change(Story, :count).by(1)
      end
    end
  end
  
  describe "story destruction" do
    before { FactoryGirl.create(:story, creator: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a story" do
        expect { click_link "delete" }.to change(Story, :count).by(-1)
      end
    end
  end
end
