class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.text :notification_params
      t.integer :task_id
      t.string :status
      t.string :transaction_id
      t.datetime :paid_at

      t.timestamps
    end
  end
end
