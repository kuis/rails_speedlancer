class AddDescriptionToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :description, :text
  end
end
