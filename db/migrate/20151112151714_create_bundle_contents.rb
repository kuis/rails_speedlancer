class CreateBundleContents < ActiveRecord::Migration
  def change
    create_table :bundle_contents do |t|
      t.integer :bundle_id
      t.string :title
      t.string :thumbnail
      t.text :description

      t.timestamps
    end
  end
end
