class TaskAttachment < ActiveRecord::Base

  mount_base64_uploader :attachment_file, AttachmentUploader

  validates :attachment_file, presence: true, on: :create
  validates :attachment_file, :file_size => {:maximum => 100.megabytes.to_i}

  belongs_to :task, :counter_cache => true

end

# == Schema Information
#
# Table name: task_attachments
#
#  id              :integer          not null, primary key
#  attachment_file :string(255)
#  task_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#
