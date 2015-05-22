class AddActiveToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :active, :boolean, :default => 0
  end
end
