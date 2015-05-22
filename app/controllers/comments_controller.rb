class CommentsController < ApplicationController

  before_action :authenticate!
  before_action :validate_task

	def create
    @comment = @task.comments.build_with_commentable(comment_params, current_buyer_or_seller)
    respond_to do |format|
      if @comment.save
        @task.reload
        format.js {}
      else
        @comment_error = @comment.errors.full_messages.first
        format.js {}
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

end
