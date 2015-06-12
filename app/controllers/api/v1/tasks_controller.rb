module Api
  module V1
    class TasksController < Api::V1::ApplicationController

      before_filter :validate_buyer_email
      before_filter :fetch_buyer

      def create
        _task_params = task_params

        @task = @buyer.tasks.new(_task_params)

        if @task.save

          if @task.payment_method == 'stripe' and params.has_key?(:stripeToken)

            begin
              customer = Stripe::Customer.create(
                :email => params[:stripeToken][:email],
                :card  => params[:stripeToken][:id]
              )

              charge = Stripe::Charge.create(
                :customer     => customer.id,
                :amount       => (_task_params[:price_in_dollars].to_f * 100).to_i,
                :description  => _task_params[:title],
                :currency     => 'usd'
              )
            rescue Exception => e
              render 'task_errors'
              return
            end

              _params = {
                :mc_gross => 0,
                :option_selection1 => 0,
                :payment_status => "Completed"
              }

              @task.update_after_payment(_params)
          elsif @task.payment_method == 'credits'
            if  @buyer.speedlancer_credits_in_dollars >= @task.price_in_dollars
              @task.activate_n_deduct_credit_from_buyer(@task.price_in_dollars)
            else
              render 'credits_error'
              return
            end
          end

          @task.create_attachments(params[:attachments]) if params[:attachments].present?

        else
          render 'task_errors'
        end
      end

      private

      def task_params
        params.require(:task).permit(:title, :description, :price_in_dollars, :buyer_id, :category_id, :payment_method, :fee_by_percent ,:source, attachments: [])
      end

      def validate_buyer_email
        render 'please_add_email' unless params[:buyer].present? and ( params[:buyer][:email].present? or params[:buyer][:bot_key].present? )
      end

      def fetch_buyer
        @buyer = Buyer.get_buyer_for_api(params[:buyer])
        render 'invalid_bot_key' if @buyer.nil?
        render 'invalid_buyer' if @buyer.present? and @buyer.errors.present?
      end
    end
  end
end
