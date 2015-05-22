class RemoveNameFromBuyerAndSeller < ActiveRecord::Migration
  def change
    remove_column :buyers, :name
    remove_column :sellers, :name
  end
end
