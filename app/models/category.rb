class Category < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true

  has_many :tasks
  has_many :sellers_categories, dependent: :destroy
  has_many :sellers, through: :sellers_categories

  # def self.tasks_in_categories
  #   Category.all.each do |category|
  #     _tasks = category.tasks.active.where(activated_at: 3.hours.ago..(Time.zone.now))
  #     category_tasks_count = _tasks.count
  #     category.sellers.each do |seller|
  #       Notifier.send_notify_sellers_about_new_tasks_email(category, category_tasks_count, seller, _tasks).deliver
  #     end
  #   end
  # end

end



# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
