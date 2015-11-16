class ProductsController < ApplicationController
	before_action :authenticate!
	
	def show
		@product = Product.find_by_id(params[:id])
		@categories = Category.all
		@products = Product.active
		@bundles = Bundle.active

		unless request.xhr?
			render 'pages/index', layout: 'resp'
		end
	end
end