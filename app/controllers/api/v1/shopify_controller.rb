module Api
  module V1
    class ShopifyController < Api::V1::ApplicationController

      before_filter :validate_shopifyinfo

      def create

        _params = shopify_info_params
        
        @info = ShopifyInfo.find_or_initialize_by :url=>_params[:url]

        if @info.update_attributes(_params)
          render 'info_save'
        else
          render 'info_save_error'
        end
      end

      private

      def shopify_info_params
        params.permit(:name, :email, :url)
      end

      def validate_shopifyinfo
        render 'invalid_params' unless params[:name].present? and params[:email].present? and params[:url].present?
      end
    end
  end
end
