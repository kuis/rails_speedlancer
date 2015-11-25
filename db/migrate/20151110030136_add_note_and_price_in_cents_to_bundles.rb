class AddNoteAndPriceInCentsToBundles < ActiveRecord::Migration
  def change
  	add_column :bundles, :note, :string
  	add_column :bundles, :price_in_cents, :integer
  end
end
