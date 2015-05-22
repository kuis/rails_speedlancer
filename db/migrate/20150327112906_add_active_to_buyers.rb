class AddActiveToBuyers < ActiveRecord::Migration
  def change
  	add_column :buyers, :active, :boolean, :default => 0
  end
end
