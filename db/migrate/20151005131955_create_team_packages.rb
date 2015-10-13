class CreateTeamPackages < ActiveRecord::Migration
  def change
    create_table :team_packages do |t|
      t.string :title
      t.string :cycle
      t.integer :cost
      t.integer :members

      t.timestamps
    end
  end
end
