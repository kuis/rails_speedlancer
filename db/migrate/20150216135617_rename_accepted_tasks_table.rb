class RenameAcceptedTasksTable < ActiveRecord::Migration
  def change
    rename_table :accepted_tasks, :sellers_tasks
  end
end
