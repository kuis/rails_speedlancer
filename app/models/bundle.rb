class Bundle < ActiveRecord::Base
	validates :title, :description, :category_id, presence: true

    belongs_to :category

    enum status: [ :active, :inactive ]

    mount_uploader :thumbnail, AttachmentUploader
end
