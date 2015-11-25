class ChangeNoteTypeInBundles < ActiveRecord::Migration
  def change
  	change_column :bundles, :note, :text
  end
end
