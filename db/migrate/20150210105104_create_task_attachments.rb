class CreateTaskAttachments < ActiveRecord::Migration
  def change
    create_table :task_attachments do |t|
      t.string :attachment_file
      t.integer :task_id

      t.timestamps
    end
    add_index :task_attachments, :task_id
  end
end
