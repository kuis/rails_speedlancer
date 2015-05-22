class PaymentNotificationsController < ApplicationController

  protect_from_forgery except: [:hook, :credit_hook]
  before_action :check_transaction_uniqueness, only: [:hook]

  def hook
    params.permit!
    _task = Task.find params[:invoice]
    _payment_notification = _task.payment_notifications.create(notification_params: params, status: status, transaction_id: params[:txn_id], paid_at: Time.zone.now)
    _task.update_after_payment(params) if _payment_notification.persisted?
    render nothing: true
  end

  def credit_hook
    params.permit!
    _buyer = Buyer.find params[:invoice]
    _payment_notification = _buyer.payment_notifications.create(notification_params: params, status: status, transaction_id: params[:txn_id], paid_at: Time.zone.now)
    _buyer.check_status_and_add_credits(params) if _payment_notification.persisted?
    render nothing: true
  end

  private
    def check_transaction_uniqueness
      payment_notification = PaymentNotification.find_by_transaction_id(params[:txn_id])
      (render nothing: true and return) if payment_notification.present?
    end

end
