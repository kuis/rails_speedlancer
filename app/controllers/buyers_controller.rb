class BuyersController < ApplicationController
  protect_from_forgery except: [:active_tasks]

  before_action :authenticate!, only: [:active_tasks, :in_progress_tasks, :completed_tasks, :team, :update_team, :subscribe, :update_team_plan, :add_teammember]
  before_action :validate_buyer, except: [:add_credits, :reset_bots]
  before_action :validate_current_buyer, only: [:team, :update_team, :subscribe, :update_team_plan, :add_teammember]


  # skip_before_action :authenticate!, only: [:reset_bots]

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

  def reset_bots
    @buyers = Buyer.where("(bot_key IS NOT NULL AND bot_key != '') OR (bot_pid IS NOT NULL AND bot_pid != '')")
    for _buyer in @buyers
      unless _buyer.bot_pid.blank?
        _buyer.kill_bot
      end

      unless _buyer.bot_key.blank?
        _buyer.create_bot  
      end
      
      _buyer.save
    end
    render "bots"
  end

  def team
    Team.expires
    redirect_to buyer_subscribe_path(@buyer) if @buyer.team.nil?
  end

  def update_team
    seller_ids = params[:team][:seller_ids].reject { |c| c.empty? }
    @buyer.team.update(seller_ids: seller_ids)
    redirect_to buyer_team_path(@buyer), notice: "MyTeam is updated"
  end

  def add_teammember
    seller = Seller.find_by_id(params[:seller_id])

    unless @buyer.team.nil? or @buyer.team.inactive?
      if @buyer.team.members > @buyer.team.sellers.count
        @buyer.team.sellers << seller
        redirect_to buyer_team_path(@buyer), notice: "MyTeam is updated"
      else
        redirect_to buyer_team_path(@buyer), alert: "MyTeam can has only #{@buyer.team.members} #{"members".pluralize(@buyer.team.members)}"
      end
    else
      redirect_to buyer_subscribe_path(@buyer), alert: "You have to subscribe for MyTeam." if @buyer.team.nil?
      redirect_to buyer_subscribe_path(@buyer), alert: "MyTeam is expired, renew for MyTeam." unless @buyer.team.nil? or @buyer.team.active?
    end
  end

  def update_team_plan
    package = TeamPackage.find_by_id(params[:package_id])
    if !package.nil? and package.members > 0
      if @buyer.purchase_team(package)
        redirect_to buyer_subscribe_path(@buyer), notice: 'You have subscribed to Team'
      else
        if @buyer.speedlancer_credits_in_dollars < package.cost_in_dollars
          redirect_to buyer_subscribe_path(@buyer), alert: 'You have not enough credits on SPEEDLANCER'
        else
          redirect_to buyer_subscribe_path(@buyer), alert: 'Too many freelancer on MyTeam now.'
        end
      end
    end
  end

  protected
  def validate_buyer
    @buyer = (Buyer.find_by_id(params[:id]) or Buyer.find_by_id(params[:buyer_id]))
    redirect_to tasks_path if @buyer.blank?
  end

  def validate_current_buyer
    @buyer = (Buyer.find_by_id(params[:id]) or Buyer.find_by_id(params[:buyer_id]))
    redirect_to tasks_path if current_buyer.id != @buyer.id
  end

end
