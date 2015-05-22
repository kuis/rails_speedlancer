class PayOut < ActiveRecord::Base

  belongs_to :seller

  enum status: [ :unpaid, :paid]

  def self.unpaid_to_csv
    CSV.generate do |csv|
      csv << ["paypal_email", "amount", "currency", "order_number"]
      self.unpaid.each do |payout|
        csv << [payout.paypal_email, payout.amount, "USD", payout.id]
      end
    end
  end

end

# == Schema Information
#
# Table name: pay_outs
#
#  id           :integer          not null, primary key
#  seller_id    :integer
#  amount       :float(24)
#  status       :integer          default(0)
#  paypal_email :string(255)
#  currency     :string(255)
#  paid_at      :datetime
#  created_at   :datetime
#  updated_at   :datetime
#
