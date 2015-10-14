class AddTeamableToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :teamable, :boolean, :default => false
  end
end
