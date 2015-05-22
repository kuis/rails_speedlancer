class SellersCategory < ActiveRecord::Base

  belongs_to :seller
  belongs_to :category

end

# == Schema Information
#
# Table name: sellers_categories
#
#  id          :integer          not null, primary key
#  seller_id   :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#
