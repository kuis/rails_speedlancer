class Comment < ActiveRecord::Base

  validates :body, presence: true

  belongs_to :task, :counter_cache => true
  belongs_to :commentable, polymorphic: true

  after_commit :notify_buyer_about_comment, on: :create

  def self.build_with_commentable(_params, buyer_or_seller)
    _comment = self.new(_params)
    _comment.commentable = buyer_or_seller
    return _comment
  end


  def notify_buyer_about_comment
    _buyer = task.buyer
    unless _buyer == commentable
      _commenter = self.commentable
      Notifier.send_comment_to_buyer_email(self, task, _buyer, _commenter).deliver
    end
  end
  handle_asynchronously :notify_buyer_about_comment

end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  task_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#
