namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_stories
    make_relationships
  end
end

def make_users
  admin = User.create!(display_name: "Hello Kitty",
               email: "hk@example.com",
               password: "foobar",
               password_confirmation: "foobar",
               user_type: 0)
  admin.toggle!(:admin)
  
  99.times do |n|
    name  = Faker::Name.name
    email = "person-#{n+1}@example.com"
    password  = "password"
    User.create!(display_name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 user_type: 0)
  end
  
  100.times do |n|
    name = Faker::Address.street_name
    User.create!(display_name: name,
                       email: '',
                       user_type: 1)
   end
                       
   100.times do |n|
     name = Faker::Company.name
     email = "shop-#{n+1}@example.com"
     password  = "password"
     User.create!(display_name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 user_type: 2)
   end
end
    
def make_stories
  users = User.all
  residence = users[0..6]
  50.times do
    content = Faker::Lorem.sentence(5)
    residence.each { |user| user.create_stories.create!(content: content, owner_id: user.id) }
  end
  
  attractions = users[100..106]
  user = users.first
  20.times do
    content = Faker::Lorem.sentence(5)
    attractions.each { |attr| user.create_stories.create!(content: content, owner_id: attr.id) }
  end
  
  shops = users[200..206]
  20.times do
    content = Faker::Lorem.sentence(5)
    shops.each { |shop| shop.create_stories.create!(content: content, owner_id: shop.id) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  friends = users[2..50]
  attractions = users[100..106]
  shops = users[200..206]
  receivers = users[3..40]
  friends.each { |friend| user.receive!(friend) }
  attractions.each { |attr| user.receive!(attr) }
  shops.each { |shop| user.receive!(shop) }
  receivers.each { |receiver| receiver.receive!(user) }
end