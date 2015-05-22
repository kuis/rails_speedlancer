class RemoveDeadlineFromSellersSubmissions < ActiveRecord::Migration
  def change
    remove_column :sellers_submissions, :deadline, :datetime
  end
end
