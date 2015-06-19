class AddFeedbackToSellersSubmissions < ActiveRecord::Migration
  def change
    add_column :sellers_submissions, :feedback, :text
  end
end
