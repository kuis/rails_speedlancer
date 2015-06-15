class AddAcceptedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :accepted_at, :datetime
  end
end
