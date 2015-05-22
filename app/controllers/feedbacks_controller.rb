class FeedbacksController < ApplicationController

  before_action :authenticate!
  before_action :validate_task

  def create
    @feedback = @task.build_feedback_with_buyer_seller(feedback_params,current_buyer, @task.present_seller)
    respond_to do |format|
      if @feedback.save
        format.js {}
      else
        format.js {}
      end
    end
  end

  private
    def feedback_params
      params.require(:feedback).permit(:body, :rating)
    end
end
