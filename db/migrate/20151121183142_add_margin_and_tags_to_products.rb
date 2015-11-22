class AddMarginAndTagsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :margin, :integer, :default => 30
    add_column :products, :tags, :string
  end
end
