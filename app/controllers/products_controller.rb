class ProductsController < ApplicationController
	
	def show
		@product = Product.find_by_id(params[:id])
		@products = Product.active
		@bundles = Bundle.active

		unless request.xhr?
			render 'pages/index', layout: 'resp'
		end
	end
end