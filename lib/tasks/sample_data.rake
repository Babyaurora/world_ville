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
               country: "China",
               state: "Jilin",
               city: "Changchun",
               zipcode: "",
               password: "foobar",
               password_confirmation: "foobar",
               house_id: 1,
               user_type: 0)
  admin.toggle!(:admin)
  
  99.times do |n|
    name  = Faker::Name.name
    email = "person-#{n+1}@example.com"
    password  = "password"
    country = Faker::Address.country
    state = Faker::Address.state
    city = Faker::Address.city
    User.create!(display_name: name,
                 email: email,
                 country: country,
                 state: state,
                 city: city,
                 zipcode: '',
                 password: password,
                 password_confirmation: password,
                 house_id: n%5+1,
                 user_type: 0)
  end
  
  User.create!(display_name: "Forbidden City",
               email: "",
               country: "China",
               state: "Beijing",
               city: "Beijing",
               zipcode: "",
               founder_id: 1,
               house_id: 1,
               user_type: 1)
               
  99.times do |n|
    name = Faker::Address.street_name
    country = Faker::Address.country
    state = Faker::Address.state
    city = Faker::Address.city
    User.create!(display_name: name,
                       email: '',
                       country: country,
                       state: state,
                       city: city,
                       zipcode: '',
                       founder_id: n%4+1,
                       house_id: n%5+1,
                       user_type: 1)
   end
                       
   100.times do |n|
     name = Faker::Company.name
     email = "shop-#{n+1}@example.com"
     country = Faker::Address.country
    state = Faker::Address.state
    city = Faker::Address.city
     password  = "password"
     User.create!(display_name: name,
                 email: email,
                 country: country,
                 state: state,
                 city: city,
                 zipcode: '',
                 password: password,
                 password_confirmation: password,
                 house_id: n%5+1,
                 user_type: 2)
   end
end
    
def make_stories
  users = User.all
  residence = users[0..6]
  10.times do
    content = Faker::Lorem.sentence(5)
    residence.each { |user| user.create_stories.create!(content: content, owner_id: user.id) }
  end
  
  attractions = users[100..106]
  user = users.first
  4.times do
    content = Faker::Lorem.sentence(5)
    attractions.each { |attr| user.create_stories.create!(content: content, owner_id: attr.id) }
  end
  
  shops = users[200..206]
  4.times do
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