class PagesController < ApplicationController
	
	def index
		@products = Product.active
		@bundles = Bundle.active
		render layout: "resp"
	end

	def search
		@q = params[:q]
		redirect_to root_path if @q.nil?

		@products = Product.active.__elasticsearch__.search(@q).records
		@bundles = Bundle.active.__elasticsearch__.search(@q).records
		render :layout => 'resp'
	end

	def purchase
		if buyer_signed_in?
			redirect_to new_task_path(:product => params[:product])
		else
			_buyer = Buyer.find_or_initialize_by email: params[:buyer]

			unless _buyer.new_record?
				redirect_to login_path, :alert => 'You have to login first'
			else
				_buyer.name = "Buyer"
				_buyer.skip_confirmation!
				_password = Devise.friendly_token.first(8)
				_buyer.password = _password
				_buyer.save
				Notifier.send_account_credentials_to_buyer(_buyer.password, _buyer).deliver
				sign_in _buyer

				redirect_to new_task_path(:product => params[:product]), :notice => "Your current password is 'password', Please reset it before signout"
			end
		end
	end
end