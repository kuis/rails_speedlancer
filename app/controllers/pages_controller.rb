class PagesController < ApplicationController
	before_action :authenticate!
	
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
end