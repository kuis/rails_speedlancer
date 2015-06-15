class CreateSubmissionAttachments < ActiveRecord::Migration
  def change
    create_table :submission_attachments do |t|
      t.string :submission
      t.integer :sellers_submission_id
      t.timestamps
    end
    add_index :submission_attachments, :sellers_submission_id
  end
end
