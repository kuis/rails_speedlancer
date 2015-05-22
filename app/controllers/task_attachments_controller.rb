class TaskAttachmentsController < ApplicationController

  before_action :authenticate!

	def download_file
		task_attachment=TaskAttachment.find_by_id(params[:id])
		send_file(task_attachment.attachment_file.path)
	end

  def authenticate!
    redirect_to new_buyer_session_path, notice: "Please sign in before continuing" unless current_buyer_seller_or_admin.present?
  end

end
