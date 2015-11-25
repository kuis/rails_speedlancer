class AddEtaToProducts < ActiveRecord::Migration
  def change
    add_column :products, :eta, :integer, :default => 4
  end
end
