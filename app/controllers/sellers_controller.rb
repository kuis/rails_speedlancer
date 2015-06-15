class SellersController < ApplicationController

  before_action :validate_seller
  before_action :authorized_seller, only: [:active_tasks, :completed_tasks, :tasks_feedbacks]


  def active_tasks
    @tasks = @seller.accepted_tasks.progress_or_review.paginate( page: params[:page], per_page: 30)
    render "tasks"
  end

  def completed_tasks
    @tasks = @seller.accepted_tasks.completed.paginate( page: params[:page], per_page: 30)
    render "tasks"
  end

  def tasks_feedbacks
    @tasks = @seller.accepted_tasks.completed.paginate( page: params[:page], per_page: 30)
  end

  protected

  def validate_seller
    @seller = (Seller.find_by_id(params[:id]) or Seller.find_by_id(params[:seller_id]))
    redirect_to tasks_path if @seller.blank?
  end

  def authorized_seller
    redirect_to root_path, notice: "Not authorized" unless seller_signed_in? or buyer_signed_in?
  end
end
