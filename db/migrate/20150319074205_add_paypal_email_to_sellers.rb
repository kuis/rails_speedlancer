class AddPaypalEmailToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :paypal_email, :string
  end
end
