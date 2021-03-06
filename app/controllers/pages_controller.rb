class PagesController < ApplicationController
	
	before_action :seller_login?

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

				Notifier.delay.send_account_credentials_to_buyer(_password, _buyer)
				sign_in _buyer

				redirect_to new_task_path(:product => params[:product]), :notice => "We sent your account detail with email"
			end
		end
	end

	def seller_login?
		if seller_signed_in?
			redirect_to seller_active_tasks_path(current_seller)
		end
	end
end