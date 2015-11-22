class AddSubheadingToProducts < ActiveRecord::Migration
  def change
    add_column :products, :subheading, :string
  end
end
