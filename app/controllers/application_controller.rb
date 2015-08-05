class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  require 'will_paginate/array'

  def current_buyer_or_seller
    current_buyer or current_seller
  end
  helper_method :current_buyer_or_seller

  def current_buyer_seller_or_admin
    current_buyer or current_seller or current_admin_user
  end
  helper_method :current_buyer_seller_or_admin

  def validate_task
    @task = Task.find_by_id(params[:task_id])
    redirect_to root_path unless @task.present?
  end

  def fetch_categories
    @categories = Category.all
  end

  def authenticate!
    redirect_to login_path, notice: "Please sign in before continuing" unless current_buyer_or_seller.present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) {|buyer| buyer.permit(:first_name, :last_name, :email, :password, :current_password, :avatar, :paypal_email, :bot_key)}
  end

end
