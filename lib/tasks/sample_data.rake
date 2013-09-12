namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
   admin = User.create!(name: "Dilip Kokate",
                 email: "dkokate@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    users = User.all(limit: 6)
    50.times do |n|
      # name = Faker::Lorem.sentence(2)
      # instructions = Faker::Lorem.sentence(3)
      name = "Secret Sauce-#{n}"
      instructions = "Abra-#{n} Dabra Mumbra-#{n}"
      users.each { |user| user.recipes.create!(name: name, instructions: instructions) }
    end
  end
end