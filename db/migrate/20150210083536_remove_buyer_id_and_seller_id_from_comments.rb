class RemoveBuyerIdAndSellerIdFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :seller_id, :integer
    remove_column :comments, :buyer_id, :integer
  end
end
