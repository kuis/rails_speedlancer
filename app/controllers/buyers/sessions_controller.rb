class Buyers::SessionsController < Devise::SessionsController

  before_filter :check_admin_signed_in, only: :sign_in_as_buyer
  before_filter :logout_current_seller, only: :sign_in_as_buyer

  def new
    if seller_signed_in?
      redirect_to root_path, notice: 'First logout from seller then login as buyer'
    else
      super
    end
  end

  def create
    # Writing this method becasue login from one form is required.
    # I know this is not right way but this is client requirement.
    # If found better way please message me as well Peeyush ;)
    _email = params[:buyer][:email]
    _password = params[:buyer][:password]
    _seller = Seller.find_by_email(_email)
    _buyer = Buyer.find_by_email(_email)
    if _seller.present? and _seller.valid_password?(_password)
      sign_in("seller", _seller)
      if _seller.accepted_tasks.present?
        redirect_to seller_active_tasks_path(_seller)
      else
        redirect_to root_path
      end
    elsif _buyer.present? and _buyer.valid_password?(_password)
      sign_in("buyer", _buyer)
      redirect_to buyer_active_tasks_path(_buyer)
    else
      redirect_to login_path, alert: "Invalid email or password"
    end
  end

  def sign_in_as_buyer
    _buyer = Buyer.find_by_id params[:buyer_id]
    if _buyer.present? and _buyer.confirmed?
      sign_in("buyer", _buyer)
      redirect_to root_path, notice: "Signed in as buyer"
    else
      redirect_to admin_buyers_path, notice: "Record not approved"
    end
  end

  def after_sign_in_path_for(buyer)
    buyer_active_tasks_path(buyer)
  end

  def check_admin_signed_in
    redirect_to root_path, notice: 'Unauthorized Access' unless current_admin_user.present?
  end

  def logout_current_seller
    if current_seller
      sign_out :seller
    end
  end

end
