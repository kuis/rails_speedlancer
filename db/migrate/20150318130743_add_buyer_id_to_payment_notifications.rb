class AddBuyerIdToPaymentNotifications < ActiveRecord::Migration
  def change
    add_column :payment_notifications, :buyer_id, :integer
  end
end
