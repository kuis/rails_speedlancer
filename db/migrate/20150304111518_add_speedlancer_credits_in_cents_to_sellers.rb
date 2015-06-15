class AddSpeedlancerCreditsInCentsToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :speedlancer_credits_in_cents, :integer, default: 0
  end
end
