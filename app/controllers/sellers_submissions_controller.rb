class SellersSubmissionsController < ApplicationController

  before_action :authenticate!
  before_action :check_submission_count, only: [:approve, :revise, :create]
  before_action :validate_task
  before_action :authorize_buyer, only: [:approve, :revise]
  before_action :fetch_submission_from_params, only: [:approve, :revise, :download_submission]
  before_action :check_submission_status, only: [:approve]

  def index
    @sellers_submissions = @task.sellers_submissions
  end

  def create
    if @task.deadline >= Time.zone.now
      _sellers_submission, _submission_created = @task.create_sellers_submission_for_seller(submission_params, current_seller, @task)
      if _submission_created
        respond_to do |format|
          format.js
        end
      else
        @submission_error = _sellers_submission.errors.full_messages.first
      end
    else
      @time_up = true
    end
  end

  def approve
    @sellers_submission.add_credits_and_update_task!
    redirect_to task_path(@task), notice: "Task has approved!"
  end

  def revise
    @sellers_submission.mark_for_revision!
    redirect_to task_path(@task), notice: "Task needs revision"
  end

  def download_submission
    send_file(@sellers_submission.submission.path)
  end

  protected
    def submission_params
      params.require(:sellers_submission).permit(:submission, :remark, submission_attachments_attributes: [:submission, :_destroy, :id])
    end

    def check_submission_count
      if @task.present? and @task.sellers_submissions.count > 3
        redirect_to task_path(@task), notice: "Maximum number of submission reached!"
      end
    end

    def authorize_buyer
      redirect_to root_path unless current_buyer == @task.buyer
    end

    def fetch_submission_from_params
      @sellers_submission = SellersSubmission.find(params[:id])
    end

    def check_submission_status
      redirect_to task_path(@task), notice: "Unauthorized access!" unless @sellers_submission.in_review?
    end

    def authenticate!
      if action_name == "download_submission"
        redirect_to new_buyer_session_path, notice: "Please sign in before continuing" unless current_buyer_seller_or_admin.present?
      else
        redirect_to new_buyer_session_path, notice: "Please sign in before continuing" unless current_buyer_or_seller.present?
      end
    end

end
