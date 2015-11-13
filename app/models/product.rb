class Product < ActiveRecord::Base
	validates :title, :description, :category_id, presence: true

	belongs_to :category

	enum status: [ :active, :inactive ]

	mount_uploader :thumbnail, AttachmentUploader

	def price
		self.price_in_cents.to_d / 100 if self.price_in_cents
	end

	def price=(dollars)
		self.price_in_cents = dollars.to_d * 100 if dollars.present?
	end
end
