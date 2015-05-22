class ChangeStringToTextInFeedbacks < ActiveRecord::Migration
  def change
    change_column :feedbacks, :body, :text
  end
end
