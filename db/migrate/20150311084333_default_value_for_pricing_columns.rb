class DefaultValueForPricingColumns < ActiveRecord::Migration
  def change
    change_column :tasks, :price_in_cents, :integer, default: 0
  end
end
