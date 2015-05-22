module CommentHelper
  def display_relevant_comments_closed_message(_task)
    if _task.in_progress? or _task.in_review?
      _seller = Seller.find _task.present_seller_id
      _buyer  = _task.buyer
      if current_buyer == _buyer or current_seller == _seller
        "Comment section has been closed as task has been accepted. Please use Private Messaging tab for further communication."
      else
        "Comments are closed for now."
      end
    else
      "Comments closed!"
    end
  end
end
