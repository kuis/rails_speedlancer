class RemoveCategoryIdFromBundles < ActiveRecord::Migration
  def change
    remove_column :bundles, :category_id, :integer
  end
end
