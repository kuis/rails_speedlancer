class AddSellerIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :seller_id, :integer
  end
end
