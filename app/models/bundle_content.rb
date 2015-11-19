class BundleContent < ActiveRecord::Base
	validates :title, :description, :thumbnail, presence: true

	belongs_to :bundle

    mount_uploader :thumbnail, AttachmentUploader
end
