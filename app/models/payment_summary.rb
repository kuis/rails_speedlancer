class PaymentSummary < ActiveRecord::Base

  belongs_to :task

  def update_buyer_values(_paypal_part, _credits_part)
    self.paypal_part += _paypal_part
    self.credits_used += _credits_part
    self.total_payment = (paypal_part + credits_used)
    self.save!
  end
  handle_asynchronously :update_buyer_values

  def update_seller_value(_seller_credits)
    self.seller_credits = _seller_credits
    self.save!
  end
  handle_asynchronously :update_seller_value
end

# == Schema Information
#
# Table name: payment_summaries
#
#  id             :integer          not null, primary key
#  task_id        :integer
#  total_payment  :float(24)        default(0.0)
#  credits_used   :float(24)        default(0.0)
#  paypal_part    :float(24)        default(0.0)
#  seller_credits :float(24)        default(0.0)
#  created_at     :datetime
#  updated_at     :datetime
#
