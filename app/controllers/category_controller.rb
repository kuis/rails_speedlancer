class CategoryController < ApplicationController

  before_action :authenticate!
  before_action :fetch_categories
  before_action :validate_category
  before_action :check_autherized_seller_category, only: [:show]

  def show
    @tasks = @category.tasks.active.paginate( page: params[:page], per_page: 30)
  end

  private

  def validate_category
    @category = Category.find_by_id params[:id]
    redirect_to root_path unless @category.present?
  end

  def check_autherized_seller_category
    @seller = current_seller
    if @seller.present? 
      redirect_to root_path, notice: "You are not authorized"  unless @seller.categories.include?(@category)
    end
  end

end
