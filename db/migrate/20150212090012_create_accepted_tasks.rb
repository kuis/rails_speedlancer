class CreateAcceptedTasks < ActiveRecord::Migration
  def change
    create_table :accepted_tasks do |t|
      t.integer :seller_id
      t.integer :task_id

      t.timestamps
    end
    add_index :accepted_tasks, :seller_id
    add_index :accepted_tasks, :task_id
  end
end
