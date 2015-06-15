class ShopifyInfo < ActiveRecord::Base
	validates :email, :email_format => true
	validates :name, :presence => true
	validates :url, :presence => true, :uniqueness => true
end
