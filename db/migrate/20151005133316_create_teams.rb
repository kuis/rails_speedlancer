class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :buyer_id
      t.integer :package_id
      t.datetime :deadline
      t.integer :members
      t.integer :status

      t.timestamps
    end
  end
end
