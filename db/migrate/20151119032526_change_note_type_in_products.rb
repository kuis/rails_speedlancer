class ChangeNoteTypeInProducts < ActiveRecord::Migration
  def change
  	change_column :products, :note, :text
  end
end
