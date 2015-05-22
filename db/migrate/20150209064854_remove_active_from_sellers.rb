class RemoveActiveFromSellers < ActiveRecord::Migration
  def change
    remove_column :sellers, :active, :boolean
  end
end
