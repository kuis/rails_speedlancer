class AddUrlToMetainfos < ActiveRecord::Migration
  def change
    add_column :metainfos, :url, :string
  end
end
