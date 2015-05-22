class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :price_in_cents
      t.references :buyer, index: true

      t.timestamps
    end
  end
end
