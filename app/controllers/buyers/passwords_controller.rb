class Buyers::PasswordsController < Devise::PasswordsController

	def new
		self.resource = resource_class.new
	end

	def create
		_email = params[:buyer][:email]
		_buyer = Buyer.find_by_email(_email)
		_seller= Seller.find_by_email(_email)
		if _seller.present?
	    	_seller.send_reset_password_instructions
	    	redirect_to login_path, notice: "Reset password email sent"
		elsif _buyer.present?
			_buyer.send_reset_password_instructions
			redirect_to login_path, notice: "Reset password email sent"
		else
			redirect_to login_path, alert: "Invalid email"
	    end
	end

end
