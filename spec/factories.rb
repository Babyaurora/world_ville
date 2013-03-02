FactoryGirl.define do
  factory :user do
    display_name                "Hello Kitty"
    email                             "hk@example.com"
    password                       "foobar"
    password_confirmation  "foobar"
    user_type                       0
  end
end