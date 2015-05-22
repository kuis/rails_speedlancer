class PaymentNotification < ActiveRecord::Base

  belongs_to :task
  belongs_to :buyer
  serialize :notification_params
end

# == Schema Information
#
# Table name: payment_notifications
#
#  id                  :integer          not null, primary key
#  notification_params :text
#  task_id             :integer
#  status              :string(255)
#  transaction_id      :string(255)
#  paid_at             :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  buyer_id            :integer
#
