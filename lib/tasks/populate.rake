require 'faker'

namespace :db do
  desc "Erase and fill database"
  task :reset_and_populate => :environment do
    require 'faker'

    # Rake::Task['db:reset'].invoke

    category_array = "Data Entry,Writing,Design,Development,Research".split(",")

    category_array.each do |category_name|
      category = Category.create!(name: category_name)
      puts category.inspect
    end

    emails_string = "rahul@fizzysoftware.com, peeyush@fizzysoftware.com, sahil@fizzysoftware.com, taroon@fizzysoftware.com, sudhanshu@fizzysoftware.com, adam@speedlancer.com"
    email_array = emails_string.split(",").each {|email| email.strip!}

    email_array.each do |email|
      admin = AdminUser.create(email: email, password: "speedlancer")
      puts admin.inspect

      seller = Seller.create(email: email, password: "testing", approved: true, speedlancer_credits_in_cents: 8700000)
      puts seller.inspect

      seller.categories << Category.find(rand(1..5))
      seller.save
    end

    emails_string_buyer = "rahul-buyer@fizzysoftware.com, peeyush-buyer@fizzysoftware.com, sahil-buyer@fizzysoftware.com, taroon-buyer@fizzysoftware.com, sudhanshu-buyer@fizzysoftware.com, adam-buyer@speedlancer.com"
    email_array_buyer   = emails_string.split(",").each {|email| email.strip!}

    email_array_buyer.each do |email|
      buyer = Buyer.create(email: email, password: "testing", speedlancer_credits_in_cents: 5000000)
    end

    100.times do |t|
      task = Task.create!(title: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(15),
             buyer_id: rand(1..5), price_in_cents: rand(1000..5000),
             category_id: rand(1..5), activated_at: Time.zone.now, status: "active")
    end

  end

  task :fix_task_category => :environment do
    Task.all.each {|task| task.update_attributes(category_id: rand(1..10))}
  end
end
