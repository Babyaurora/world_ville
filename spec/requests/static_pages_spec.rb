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
        FactoryGirl.create(:story, creator: user, content: "Lorem ipsum")
        FactoryGirl.create(:story, creator: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "senders/receivers counts" do
        let(:friend) { FactoryGirl.create(:user) }
        let(:attraction) { FactoryGirl.create(:attraction) }
        let(:shop) { FactoryGirl.create(:shop) }
        before do
          user.receive!(friend) 
          user.receive!(attraction) 
          user.receive!(shop) 
          visit root_path
        end

        it { should have_link("1 friends", href: friends_user_path(user)) }
        it { should have_link("1 attractions", href: attractions_user_path(user)) }
        it { should have_link("1 shops", href: shops_user_path(user)) }
      end
    end
  end
end
