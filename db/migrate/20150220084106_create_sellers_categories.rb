class CreateSellersCategories < ActiveRecord::Migration
  def change
    create_table :sellers_categories do |t|
      t.integer :seller_id
      t.integer :category_id

      t.timestamps
    end
    add_index :sellers_categories, :seller_id
    add_index :sellers_categories, :category_id
  end
end
