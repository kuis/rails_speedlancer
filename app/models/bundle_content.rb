class BundleContent < ActiveRecord::Base
	validates :title, :description, :bundle, :thumbnail, presence: true

	belongs_to :bundle

    mount_uploader :thumbnail, AttachmentUploader
end
