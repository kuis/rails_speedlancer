class Sellers::RegistrationsController < Devise::RegistrationsController

  def new
    redirect_to new_seller_session_path
  end

end
