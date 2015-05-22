class RenameCustomerSupportTable < ActiveRecord::Migration
  def change
    rename_table :customer_supports, :support_tickets
  end
end
