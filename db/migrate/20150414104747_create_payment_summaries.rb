class CreatePaymentSummaries < ActiveRecord::Migration
  def change
    create_table :payment_summaries do |t|
      t.integer :task_id
      t.float :total_payment, default: 0.0
      t.float :credits_used, default: 0.0
      t.float :paypal_part, default: 0.0
      t.float :seller_credits, default: 0.0

      t.timestamps
    end
    add_index :payment_summaries, :task_id
  end
end
