class SupportTicketsController < ApplicationController

  def new
    @support_ticket = SupportTicket.new
  end

	def create
		@support_ticket = SupportTicket.new(support_ticket_params)
    respond_to do |format|
      if @support_ticket.save
        format.js {}
      else
        format.js {render :new}
      end
    end
	end

	private
	def support_ticket_params
		params.require(:support_ticket).permit(:name, :email, :content)
	end


end
