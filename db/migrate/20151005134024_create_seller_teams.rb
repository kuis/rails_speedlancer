class CreateSellerTeams < ActiveRecord::Migration
  def change
    create_table :seller_teams do |t|
      t.integer :seller_id
      t.integer :team_id

      t.timestamps
    end
  end
end
