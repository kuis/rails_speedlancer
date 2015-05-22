class CreatePayOuts < ActiveRecord::Migration
  def change
    create_table :pay_outs do |t|
      t.integer :seller_id
      t.float :amount
      t.integer :status, default: 0
      t.string :paypal_email
      t.string :currency

      t.datetime :paid_at
      t.timestamps
    end
    add_index :pay_outs, :seller_id
  end
end
