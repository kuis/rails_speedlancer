class PagesController < ApplicationController
	before_action :authenticate!
	
	def index
		@categories = Category.all
		@products = Product.active
		@bundles = Bundle.active
		render layout: "resp"
	end
end