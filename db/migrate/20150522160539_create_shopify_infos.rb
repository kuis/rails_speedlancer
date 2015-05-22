class CreateShopifyInfos < ActiveRecord::Migration
  def change
    create_table :shopify_infos do |t|
      t.string :name
      t.string :email
      t.text :url

      t.timestamps
    end
  end
end
