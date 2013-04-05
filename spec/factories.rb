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
    
    factory :attraction do
      sequence(:display_name)  { |n| "Attraction #{n}" }
      email ''
      user_type 1
    end
    
    factory :shop do
      sequence(:display_name)  { |n| "Shop #{n}" }
      sequence(:email) { |n| "shop_#{n}@example.com"}  
      user_type 2
    end
  end
  
  factory :story do
    content "Lorem ipsum"
    creator FactoryGirl.create(:user)
    owner FactoryGirl.create(:user)
  end
end