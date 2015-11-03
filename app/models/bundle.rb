class Bundle < ActiveRecord::Base
    belongs_to :category

    mount_uploader :thumbnail, AttachmentUploader
end
