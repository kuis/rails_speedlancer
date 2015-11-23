# require 'elasticsearch/model'

class Product < ActiveRecord::Base
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	validates :title, :description, :category_id, :eta, presence: true

	belongs_to :category
	belongs_to :custom_seller, :foreign_key => :custom_seller_id, :class_name => "Seller"

	enum status: [ :active, :inactive ]

	mount_uploader :thumbnail, AttachmentUploader
	mount_uploader :custom_company_logo, AttachmentUploader
	mount_uploader :custom_result, AttachmentUploader

	def price
		(self.price_in_cents.to_d / 100.00).to_d if self.price_in_cents
	end

	def price=(dollars)
		self.price_in_cents = dollars.to_d * 100 if dollars.present?
	end

	def cssType
		type = 'other'

		if self.category.name.downcase == 'design'
			type = 'design'
		elsif self.category.name.downcase == 'writing'
			type = 'writing'
		end

		type
	end

	def self.cssTypes
		{
			:design => '.item-design',
			:writing => '.item-writing',
			:other => '.item-other'
		}
	end

	def eta_from_now
		deadline = Time.now + self.eta.hours
		result = ''

		if deadline.today? 
			result = 'today!'
		elsif deadline.to_date == Date.tomorrow
			result = 'tomorrow!'
		else
			result = deadline.strftime('%a, %b %d')
		end
		
		deadline.strftime('%l%P ') + result
	end
end


Product.import force: true