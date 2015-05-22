module TaskHelper

  def link_for_task_attachment_according_to_extention(_task, _task_attachment)
    _extension= _task_attachment.attachment_file.file.extension.downcase
    _name=_task_attachment.attachment_file.path.split("/").last
    if _extension == "jpg" or _extension == "png"
      link_to (image_tag _task_attachment.attachment_file.url(:thumb).to_s), download_file_task_task_attachment_path(_task, _task_attachment),target: '_blank',  class: "imagelink"
    else
      link_to (_name), download_file_task_task_attachment_path(_task, _task_attachment), target: '_blank', class: "normallink"
    end
  end

  def link_for_sellers_submissions_according_to_extention(_sellers_submsission, _submission_attachment)
    _extension= _submission_attachment.submission.file.extension.downcase
    _name=_submission_attachment.submission.path.split("/").last
    if _extension == "jpg" or _extension == "png"
      link_to (image_tag _submission_attachment.submission.url(:thumb).to_s), download_file_sellers_submission_submission_attachment_path(_sellers_submsission, _submission_attachment),target: '_blank', class: "imagelink"
    else
      link_to (_name), download_file_sellers_submission_submission_attachment_path(_sellers_submsission, _submission_attachment), target: '_blank', class: "normallink"
    end
  end

  def task_timer_status(_task)
    if _task.in_progress?
      "Waiting for task completion"
    elsif _task.in_review?
      "Waiting for customer’s approval"
    elsif _task.completed?
      "Task completed successfully"
    end
  end

  def check_completed_checkpoints(_step, _task)
    if _task.completed?
      "completed"
    elsif _task.progress_or_review?
      "completed" unless _step == 3
    elsif _task.active? and _step == 1
      "completed"
    end
  end

  def personal_messages(_task)
    if seller_signed_in?
      "These messages are visible to you and the buyer only."
    else
      "These messages are visible to you and the seller only."
    end
  end

  def pricing_wrt_current_user(_task)
    if current_buyer_or_seller.class == Seller
      number_to_currency(_task.seller_pice_in_dollars)
    else
      number_to_currency(_task.price_in_dollars)
    end
  end

end
