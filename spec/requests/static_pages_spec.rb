require 'spec_helper'

describe "StaticPages" do
  subject { page }
   
   shared_examples_for "all static pages" do |heading, page_title|
     it { should have_selector('h1', text: heading) }
     it { should have_selector('title', text: full_title(page_title)) }
   end 
end
