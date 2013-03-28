FactoryGirl.define do
  factory :user do
    sequence(:display_name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    user_type 0
    
    factory :admin do
      admin true
    end
  end
  
  factory :story do
    content "Lorem ipsum"
    creator FactoryGirl.create(:user)
    owner FactoryGirl.create(:user)
  end
end