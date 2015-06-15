class AddPaymentMehtodToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :payment_method, :string, :default => "paypal"
  end
end
