class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.integer :price_in_cents
      t.string :description
      t.string :thumbnail
      t.integer :category_id
      t.integer :status

      t.timestamps
    end
  end
end
