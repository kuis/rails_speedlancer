class BuyersController < ApplicationController
  protect_from_forgery except: [:active_tasks]

  before_action :validate_buyer, except: [:add_credits]
  before_action :authenticate!, only: [:active_tasks, :in_progress_tasks, :completed_tasks]

  def active_tasks
    @tasks = @buyer.tasks.available_tasks.paginate( page: params[:page], per_page: 30)
    render "tasks"
  end

  def in_progress_tasks
    @tasks = @buyer.tasks.progress_or_review.paginate( page: params[:page], per_page: 30)
    render "tasks"
  end

  def completed_tasks
    @tasks = @buyer.tasks.completed.paginate( page: params[:page], per_page: 30)
    render "tasks"
  end

  def lapsed_tasks
    @tasks = @buyer.tasks.lapse.paginate( page: params[:page], per_page:30)
    render "tasks"
  end

  def add_credits
    credits_in_dollars = params[:buyer][:credits_to_add].to_f
    redirect_to current_buyer.paypal_url(buyer_active_tasks_url(current_buyer), credits_in_dollars)
  end

  protected
  def validate_buyer
    @buyer = (Buyer.find_by_id(params[:id]) or Buyer.find_by_id(params[:buyer_id]))
    redirect_to tasks_path if @buyer.blank?
  end

end
