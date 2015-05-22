class SubmissionAttachmentsController < ApplicationController

  before_action :authenticate!
  before_action :validate_sellers_submission
  before_action :validate_attachment

  def download_file
    send_file(@submission_attachment.submission.path)
  end

  def authenticate!
    redirect_to new_buyer_session_path, notice: "Please sign in before continuing" unless current_buyer_seller_or_admin.present?
  end

  def validate_sellers_submission
    @sellers_submission = SellersSubmission.find_by_id params[:sellers_submission_id]
    redirect_to root_path, alert: "Record not found" unless @sellers_submission.present?
  end

  def validate_attachment
    @submission_attachment = @sellers_submission.submission_attachments.find_by_id params[:id]
    redirect_to root_path, alert: "Record not found" unless @submission_attachment.present?
  end
end


