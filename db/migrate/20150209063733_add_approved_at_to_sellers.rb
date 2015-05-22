class AddApprovedAtToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :approved_at, :datetime
  end
end
