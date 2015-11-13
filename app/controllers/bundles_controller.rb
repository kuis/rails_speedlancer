class BundlesController < ApplicationController
	
	before_action :fetch_bundle

	def show
		render layout: "resp"
	end

	private
		def fetch_bundle
			@bundle = Bundle.find_by_id(params[:id])
			redirect_to root_path , notice: "Bundle not found" unless @bundle.present?
		end
end