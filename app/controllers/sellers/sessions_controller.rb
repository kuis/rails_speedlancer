class Sellers::SessionsController < Devise::SessionsController

  before_filter :check_admin_signed_in, only: :sign_in_as_seller
  before_filter :logout_current_buyer, only: :sign_in_as_seller


  def new
    if buyer_signed_in?
      redirect_to root_path , notice: 'First logout from buyer then login as seller.'
    else
      super
    end
  end

  def sign_in_as_seller
    _seller = Seller.find_by_id params[:seller_id]
    if _seller.present? and _seller.active_for_authentication?
      sign_in("seller", _seller)
      redirect_to root_path, notice: "Signed in as seller"
    else
      redirect_to admin_sellers_path, notice: "Record not approved"
    end
  end

  def after_sign_in_path_for(seller)
    if seller.accepted_tasks.present?
      seller_active_tasks_path(seller)
    else
      root_path
    end
  end

  def check_admin_signed_in
    redirect_to root_path, notice: 'Unauthorized Access' unless current_admin_user.present?
  end

  def logout_current_buyer
    if current_buyer
      sign_out :buyer
    end
  end

end
