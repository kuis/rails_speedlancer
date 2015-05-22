class AddRemarkToSellersSubmissions < ActiveRecord::Migration
  def change
    add_column :sellers_submissions, :remark, :text
  end
end
