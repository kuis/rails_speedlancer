class Message < ActiveRecord::Base

  validates :content, presence: true

  belongs_to :task
  belongs_to :messagable, polymorphic: true

  after_commit :notify_receiver_about_message, on: :create

  def self.create_message_for_task(params, _current_buyer_or_seller, _task)
    _message = self.new(params)
    _message.messagable = _current_buyer_or_seller
    _message.save
  end

  def notify_receiver_about_message
    _buyer = task.buyer
    _seller = task.present_seller
    if messagable_type == "Seller"
      Notifier.send_message_to_buyer_email(self, task, _buyer,_seller).deliver
    else
      Notifier.send_message_to_seller_email(self, task, _buyer,_seller).deliver
    end
  end
  handle_asynchronously :notify_receiver_about_message

end

# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  task_id         :integer
#  messagable_id   :integer
#  messagable_type :string(255)
#
