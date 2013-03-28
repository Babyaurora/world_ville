namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_stories
    make_relationships
  end
end

def make_users
  admin = User.create!(display_name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               user_type: 0)
  admin.toggle!(:admin)
  
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(display_name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 user_type: 0)
  end
end
    
def make_stories
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.create_stories.create!(content: content, owner_id: user.id) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  senders = users[2..50]
  receivers = users[3..40]
  senders.each { |sender| user.receive!(sender) }
  receivers.each { |receiver| receiver.receive!(user) }
end