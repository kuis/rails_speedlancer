class AddCommentsCountToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :comments_count, :integer, :default => 0
  end
end
