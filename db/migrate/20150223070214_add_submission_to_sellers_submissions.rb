class AddSubmissionToSellersSubmissions < ActiveRecord::Migration
  def change
    add_column :sellers_submissions, :submission, :string
  end
end
