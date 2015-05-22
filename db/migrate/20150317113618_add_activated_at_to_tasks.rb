class AddActivatedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :activated_at, :datetime
  end
end
