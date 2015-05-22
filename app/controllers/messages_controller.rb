class MessagesController < ApplicationController

	before_action :authenticate!
	before_action :validate_task

	def create
    @task.messages.create_message_for_task(message_params, current_buyer_or_seller, @task)
    respond_to do |format|
      format.js {}
    end
	end

	private
		def message_params
			params.require(:message).permit(:content)
		end
end
