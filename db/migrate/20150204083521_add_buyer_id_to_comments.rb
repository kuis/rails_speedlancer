class AddBuyerIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :buyer_id, :integer
  end
end
