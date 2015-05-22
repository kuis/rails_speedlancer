class AddTaskIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :task_id, :integer
  end
end
