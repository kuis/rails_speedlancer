class AddStatusToSellersSubmissions < ActiveRecord::Migration
  def change
    add_column :sellers_submissions, :status, :integer, default: 0
  end
end
