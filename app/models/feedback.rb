class Feedback < ActiveRecord::Base

  validates :body, :rating, :buyer_id, :seller_id, presence: true

  belongs_to :task
  belongs_to :buyer
  belongs_to :seller

  after_create :notify_seller_feedback_recevied, on: :commit

  def notify_seller_feedback_recevied
    Notifier.send_seller_feedback_received_email(self, task, buyer, seller).deliver
  end
  handle_asynchronously :notify_seller_feedback_recevied

  def star_file_name
    "email/feedback" + self.rating.to_s + ".png"
  end

end

# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  body       :text
#  rating     :integer
#  buyer_id   :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  seller_id  :integer
#
