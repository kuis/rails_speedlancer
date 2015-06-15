class SellersSubmission < ActiveRecord::Base

  validate :check_no_submission?, on: :create

  belongs_to :seller
  belongs_to :task
  has_many :submission_attachments, dependent: :destroy

  after_create :notify_buyer_about_submission, on: :commit

  enum status: [:in_review, :needs_revision, :approved, :rejected]

  accepts_nested_attributes_for :submission_attachments, reject_if: :check_file_blank?, :allow_destroy => true

  def check_file_blank?(submission_attachments_attributes)
    if submission_attachments_attributes[:submission].blank?
      return true
    end
  end

  def check_no_submission?
    errors.add(:base, "Please attach file") if submission_attachments.blank? and remark.blank?
  end

  def add_credits_and_update_task!
    _seller = seller
    _task = task
    self.approved!
    _task.update_attributes(status: 3, delivered_at: Time.zone.now)
    _seller.add_credits(_task.seller_pice_in_dollars)
    _task.payment_summary.update_seller_value(_task.seller_pice_in_dollars) if _task.payment_summary.present?
  end

  def mark_for_revision!
    self.needs_revision!
    _task = task
    _task.deadline = 4.hours.from_now
    _task.status = "in_progress"
    _task.save
    notify_seller_about_revison
  end

  def notify_buyer_about_submission
    _task = task
    _buyer = task.buyer
    _seller = task.present_seller
    _submission = self
    Notifier.send_seller_submission_received_email(_submission, _task, _buyer, _seller ).deliver
  end
  handle_asynchronously :notify_buyer_about_submission

  def notify_seller_about_revison
    _buyer = task.buyer
    _seller = task.present_seller
    Notifier.send_seller_revison_requested_email(self, task, _buyer, _seller ).deliver
  end
  handle_asynchronously :notify_seller_about_revison

  def notify_seller_about_approval
    _task = task
    _buyer = task.buyer
    _seller = task.present_seller
    Notifier.send_seller_submission_approved_email(_task, _buyer, _seller ).deliver
  end
  handle_asynchronously :notify_seller_about_approval

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
