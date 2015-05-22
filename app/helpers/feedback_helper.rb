module FeedbackHelper

  def feedback_header(_task)
    action_name == "tasks_feedbacks" ? _task.title : "Feedback"
  end

end
