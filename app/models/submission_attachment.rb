class SubmissionAttachment < ActiveRecord::Base

  mount_uploader :submission, AttachmentUploader

  validates :submission, presence: true, on: :create
  validates :submission, :file_size => {:maximum => 100.megabytes.to_i}

  belongs_to :sellers_submission

end

# == Schema Information
#
# Table name: submission_attachments
#
#  id                    :integer          not null, primary key
#  submission            :string(255)
#  sellers_submission_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#
