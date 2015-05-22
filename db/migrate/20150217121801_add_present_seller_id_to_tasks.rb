class AddPresentSellerIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :present_seller_id, :integer
    add_index :tasks, :present_seller_id
  end
end
