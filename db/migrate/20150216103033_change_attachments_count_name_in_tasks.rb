class ChangeAttachmentsCountNameInTasks < ActiveRecord::Migration
  def change
  	rename_column :tasks, :attachments_count, :task_attachments_count
  end
end
