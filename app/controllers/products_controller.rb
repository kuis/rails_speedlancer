class ProductsController < ApplicationController
	before_action :authenticate!
	
	def show
		@product = Product.find_by_id(params[:id])
	end
end