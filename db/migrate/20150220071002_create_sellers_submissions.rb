class CreateSellersSubmissions < ActiveRecord::Migration
  def change
    create_table :sellers_submissions do |t|
      t.datetime :deadline
      t.integer :seller_id
      t.integer :task_id

      t.timestamps
    end
    add_index :sellers_submissions, :seller_id
    add_index :sellers_submissions, :task_id
  end
end
