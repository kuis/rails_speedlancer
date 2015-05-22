class AddSpeedlancerCreditsInCentsToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :speedlancer_credits_in_cents, :integer, default: 0
  end
end
