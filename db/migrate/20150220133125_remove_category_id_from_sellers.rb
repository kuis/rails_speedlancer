class RemoveCategoryIdFromSellers < ActiveRecord::Migration
  def change
    remove_column :sellers, :category_id
  end
end
