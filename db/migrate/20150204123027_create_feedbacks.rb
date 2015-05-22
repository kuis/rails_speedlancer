class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :body
      t.integer :rating
      t.integer :buyer_id
      t.references :task, index: true

      t.timestamps
    end
  end
end
