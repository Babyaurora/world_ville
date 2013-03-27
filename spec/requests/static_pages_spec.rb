require 'spec_helper'

describe "StaticPages" do
  subject { page }
   
   shared_examples_for "all static pages" do |heading, page_title|
     it { should have_selector('h1', text: heading) }
     it { should have_selector('title', text: full_title(page_title)) }
   end 
   
   describe "Home page" do
     describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:story, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:story, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end
end
