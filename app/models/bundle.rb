# require 'elasticsearch/model'

class Bundle < ActiveRecord::Base
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	validates :title, :description, presence: true

	has_many :bundle_contents, dependent: :destroy

	enum status: [ :active, :inactive ]

    mount_uploader :thumbnail, AttachmentUploader

    accepts_nested_attributes_for :bundle_contents, allow_destroy: true

    scope :recent, lambda { |n| order("id").last(n) }

    def price
		self.price_in_cents.to_d / 100 if self.price_in_cents
	end

	def price=(dollars)
		self.price_in_cents = dollars.to_d * 100 if dollars.present?
	end
end

Bundle.import force: true