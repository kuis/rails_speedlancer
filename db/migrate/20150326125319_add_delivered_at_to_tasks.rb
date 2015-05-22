class AddDeliveredAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :delivered_at, :datetime
  end
end
