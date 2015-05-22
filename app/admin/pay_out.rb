ActiveAdmin.register PayOut do

  actions :all, :except => [:new]

  # Index section
  filter :paypal_email, as: :string
  filter :paid_at

  scope :unpaid
  scope :paid

  index do
    selectable_column
    column "Id" do |payout|
      link_to payout.id, admin_pay_out_path(payout)
    end
    column :seller
    column :amount
    column :status
    column :paypal_email
    column :paid_at
  end

  batch_action :mark_paid, if: proc{ params[:scope] == "unpaid" } do |ids|
    _payouts = PayOut.unpaid.where(id: ids)
    _payouts.update_all(status: 1, paid_at: Time.zone.now)
    redirect_to collection_path, notice: "Marked as paid"
  end

  collection_action :import_csv do
    send_data PayOut.unpaid_to_csv
  end

  action_item :view, only: :index do
    link_to 'Export Unpaid CSV', import_csv_admin_pay_outs_path
  end

  # Show Section
  show do
    attributes_table do
      row :seller_id
      row :amount
      row :status
      row :paypal_email
      row :currency
      row :paid_at
    end
  end

end



# == Schema Information
#
# Table name: pay_outs
#
#  id           :integer          not null, primary key
#  seller_id    :integer
#  amount       :float(24)
#  status       :integer          default(0)
#  paypal_email :string(255)
#  currency     :string(255)
#  paid_at      :datetime
#  created_at   :datetime
#  updated_at   :datetime
#
