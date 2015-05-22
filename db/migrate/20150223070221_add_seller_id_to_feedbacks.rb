class AddSellerIdToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :seller_id, :integer
  end
end
