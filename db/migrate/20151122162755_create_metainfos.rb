class CreateMetainfos < ActiveRecord::Migration
  def change
    create_table :metainfos do |t|
      t.string :name
      t.text :value
    end
  end
end
