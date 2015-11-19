class BundleContent < ActiveRecord::Base
	validates :title, :description, :thumbnail, presence: true

	belongs_to :bundle, polymorphic: true

    mount_uploader :thumbnail, AttachmentUploader
end
