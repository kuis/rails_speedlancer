class AddAttachmentsCountToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :attachments_count, :integer, :default => 0
  end
end
