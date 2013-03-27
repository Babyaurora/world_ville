namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
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
    
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.stories.create!(content: content, to_user_id: user.id) }
    end
  end
end