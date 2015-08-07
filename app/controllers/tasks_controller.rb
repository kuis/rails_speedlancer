class TasksController < ApplicationController

  protect_from_forgery except: [:show]

  before_action :authenticate!
  before_action :fetch_task, only: [:show, :edit, :update, :destroy, :accept_task, :add_watcher, :remove_watcher]
  before_action :authorized_buyer, only: [:edit, :update]
  before_action :not_assigned, only: [:edit, :update, :accept_task]
  before_action :fetch_categories, only: [:index, :show, :new, :edit]
  before_action :fetch_seller, only: [:accept_task]
  before_action :fetch_seller_category, only: [:accept_task]
  before_action :check_buyer, only: [:new]

  def index
    if buyer_signed_in?
      @buyer = current_buyer
      @tasks = current_buyer.tasks.available_tasks.includes(:task_attachments, :buyer, :feedback).paginate( page: params[:page], per_page: 30)
    elsif seller_signed_in?
      @seller = current_seller
      @tasks = @seller.categorised_tasks.available_tasks.includes(:task_attachments, :buyer, :feedback).paginate( page: params[:page], per_page: 30)
    end
  end

  def new
    @task = Task.build_with_default_price
  end

  def create
    @task = current_buyer.tasks.new(task_params)
    @task.source = 'CMS'
    @task.fee_by_percent = 30

    if @task.save
      check_required_credits(@task.price_in_dollars)
      if @required_credits == 0
        redirect_to task_path(@task), notice: "Task has been created"
      else
        redirect_to @task.paypal_url(task_url(@task), @required_credits, @buyer_credits_to_remove)
      end
    else
      render :new
    end
  end

  def update
    _old_price = @task.price_in_dollars
    @task.assign_attributes(task_params)
    if @task.valid?
      check_price_changes(_old_price, @task.price_in_dollars)
      if @required_credits == 0
        @task.save
        redirect_to task_path(@task), notice: "Task has been updated"
      else
        redirect_to @task.paypal_url(task_url(@task), @required_credits, @buyer_credits_to_remove)
      end
    else
      render :edit
    end
  end

  def accept_task
    if @seller.present?
      @task.update_on_acceptance!(@seller)
      redirect_to task_path(@task), notice: "Task has been assigned to you. You have 4 hours to complete it."
    else
      redirect_to root_path, notice: "Unauthorized access!"
    end
  end

  def add_watcher
    respond_to do |format|
       @task.add_watcher(params[:seller_id].to_i)
      format.json{ render nothing: true }
    end
  end

  def remove_watcher
    respond_to do |format|
      @task.remove_watcher(params[:seller_id].to_i)
      format.json{ render nothing: true }
    end
  end

  def tasks_log
    qs = request.query_parameters
    id = qs['id']
    id = 1 if id.nil?
    @ind = id.to_i

    tasks = Task.where(["id >= ? and id < ?", @ind, @ind+100])
    @count = 0
    for task in tasks
      task.submit_event
      @count = @count + 1
    end
  end

  private
    def fetch_task
      @task = Task.includes(:comments, :task_attachments, :sellers_submissions).find_by_id(params[:id])
      redirect_to root_path , notice: "Task not found" unless @task.present?
    end

    def task_params
      params.require(:task).permit(:title, :description, :price_in_dollars, :buyer_id, :category_id, task_attachments_attributes: [:attachment_file, :_destroy, :id])
    end

    def authorized_buyer
      redirect_to root_path, notice: "Not authorized" unless @task.buyer == current_buyer
    end

    def not_assigned
      redirect_to task_path(@task), notice: "Only active tasks can be edited." unless @task.active? and @task.present_seller_id.blank?
    end

    def fetch_seller
      @seller = current_seller
    end

    def check_buyer
      redirect_to root_path, notice: "Not authorized" unless current_buyer
    end

    def fetch_seller_category
      _category = @task.category
      redirect_to root_path, notice: "You are not authorized"  unless @seller.categories.include?(_category)
    end

    def check_required_credits(_new_price)
      if _new_price <= current_buyer.speedlancer_credits_in_dollars
        @required_credits = 0
        @task.activate_n_deduct_credit_from_buyer(_new_price)
      else
        @required_credits = _new_price - current_buyer.speedlancer_credits_in_dollars
        @buyer_credits_to_remove = current_buyer.speedlancer_credits_in_dollars
      end
    end

    def check_price_changes(_old_price, _new_price)
      @required_credits = 0
      if ((_new_price > 0) and _old_price != _new_price)
        if _old_price > _new_price
          refund_amount = _old_price - _new_price
          @task.buyer.add_credits(refund_amount)
        else
          payment_pending = _new_price - _old_price
          check_required_credits(payment_pending)
        end
      end
    end

end
