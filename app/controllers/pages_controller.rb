class PagesController < ApplicationController
	def index
		@categories = Category.all
		@products = Product.active
		@bundles = Bundle.active
		render layout: "resp"
	end
end