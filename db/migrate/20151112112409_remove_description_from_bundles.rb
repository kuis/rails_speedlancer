class RemoveDescriptionFromBundles < ActiveRecord::Migration
  def change
    remove_column :bundles, :description, :string
  end
end
