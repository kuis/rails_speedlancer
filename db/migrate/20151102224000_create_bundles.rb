class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.string :title
      t.string :description
      t.string :thumbnail
      t.integer :category_id
      t.integer :status

      t.timestamps
    end
  end
end
