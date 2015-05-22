namespace :onetime do

  task :add_sellers_categories => :environment do
    Seller.all.each do |seller|
      rand(1..2).times do |t|
        seller.sellers_categories.create(category_id: rand(1..9))
      end
    end
  end

end
