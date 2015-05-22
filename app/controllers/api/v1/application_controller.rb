class Api::V1::ApplicationController < ActionController::Base

  before_filter :restrict_access

  private

  def restrict_access
    @api_key = ApiKey.find_by_access_token(params[:access_token])
    render 'api/v1/shared/restrict_access' unless @api_key
  end

end
