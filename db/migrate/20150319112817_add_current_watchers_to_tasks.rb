class AddCurrentWatchersToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :watchers, :text
  end
end
