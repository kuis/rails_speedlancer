ActiveAdmin.register SellersSubmission do

  menu priority: 5

  # Index  pages section
  config.filters = false

  permit_params :seller_id, :task_id, :status, :remark, submission_attachments_attributes: [:submission, :_destroy, :id]

  index do
    column "Id" do |sellers_submission|
      link_to sellers_submission.id, admin_sellers_submission_path(sellers_submission)
    end
    column :seller
    column :task
    column :status
  end

  show do
    attributes_table do
      row :id
      row :seller_id
      row :task_id
      row :remark
      row :status
      row :created_at
    end

    if sellers_submission.submission_attachments.present?
      panel "Submission Attachments" do
        table_for sellers_submission.submission_attachments do
          column(:submission) {|submission_attachment| link_for_sellers_submissions_according_to_extention(submission_attachment.sellers_submission, submission_attachment)}
        end
      end
    end
  end

  # form section

  form do |f|
    f.inputs "Details" do
      f.input :seller_id
      f.input :task_id
      f.input :remark
      f.input :status, as: :select, collection: SellersSubmission.statuses.keys
    end

    f.has_many :submission_attachments, heading: 'Attachments', new_record: true, allow_destroy: true do |a|
      a.input :submission
    end
    f.actions
  end


end


# == Schema Information
#
# Table name: sellers_submissions
#
#  id         :integer          not null, primary key
#  seller_id  :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  remark     :text
#  submission :string(255)
#  status     :integer          default(0)
#
