class SellersTask < ActiveRecord::Base

  validates :seller_id, uniqueness: {:scope => :task_id}
  validates :task_id, uniqueness: {:scope => :seller_id}

  # belongs_to :acceptor, class_name: "Seller", foreign_key: "acceptor_id"
  belongs_to :seller
  belongs_to :task

end

# == Schema Information
#
# Table name: sellers_tasks
#
#  id         :integer          not null, primary key
#  seller_id  :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
