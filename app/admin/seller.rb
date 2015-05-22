ActiveAdmin.register Seller do

  menu priority: 3

  # Index  pages section
  filter :email, as: :string
  filter :first_name, as: :string
  filter :last_name, as: :string
  filter :approved, as: :select

  permit_params :email, :password, :paypal_email, :password_confirmation, :first_name, :last_name, :about, :speedlancer_credits_in_dollars, :approved, sellers_categories_attributes: [:category_id, :_destroy, :id]

  actions :all, except: :destroy

  index do
    column :id
    column "Email" do |seller|
      link_to seller.email, admin_seller_path(seller)
    end
    column :first_name
    column :last_name
    column :about
    column :approved
    column "Credits" do |seller|
      number_to_currency (seller.speedlancer_credits_in_dollars)
    end
  end


  # Show Section
  show do
    attributes_table do
      row :email
      row :first_name
      row :paypal_email
      row :last_name
      row :about
      row "Credits", :speedlancer_credits_in_dollars do |seller|
        number_to_currency (seller.speedlancer_credits_in_dollars)
      end
      row :approved
      row :approved_at
      row :created_at
    end

    if seller.accepted_tasks.present?
      panel "Sellers Tasks" do
        table_for seller.accepted_tasks do
          column "Task Links(#{seller.accepted_tasks.count})" do |task|
            link_to task.title, admin_task_path(task)
          end
        end
      end
    end

    if seller.categories.present?
      panel "Categories" do
        table_for seller.categories do
          column :name
        end
      end
    end

    if seller.pay_outs.present?
      panel "Payouts" do
        table_for seller.pay_outs do
          column "Id" do |payout|
            link_to payout.id, admin_pay_out_path(payout)
          end
          column :seller
          column :amount
          column :status
          column :paypal_email
          column :paid_at
          column :created_at
        end
      end
    end

  end

  member_action :approve_seller, :method => :get do
    seller = Seller.find(params[:id])
    seller.notify_and_approve_for_sales
    redirect_to resource_path(seller),  notice: "Seller Approved and notified"
  end

  member_action :block_seller, :method => :get do
    seller = Seller.find(params[:id])
    seller.block_for_sales
    redirect_to resource_path(seller),  notice: "Seller blocked"
  end

  action_item :view, only: :show do
    if resource.approved
      link_to 'Block Seller', block_seller_admin_seller_path(resource)
    else
      link_to 'Approve', approve_seller_admin_seller_path(resource)
    end
  end
  action_item :view, only: :show do
     link_to 'Login as seller', sign_in_as_seller_path(seller_id: resource.id), :target => "_blank"
  end


  controller do

    def create
      _password = params[:seller][:password]
      @seller = Seller.new permitted_params["seller"]
      if @seller.save
        redirect_to admin_seller_path(@seller)
        @seller.notify_seller_about_account_details(_password)
      else
        render :new
      end
    end

  end

  # form section

  form do |f|
    f.inputs "Details" do
      f.input :email, label: "Seller Email"
      f.input :paypal_email, label: "Paypal account email"
      f.input :password
      f.input :first_name, label: "First Name"
      f.input :last_name, label: "Last Name"
      f.input :about
      f.input :approved unless f.object.new_record?
      f.input :speedlancer_credits_in_dollars, label: "Credits"
    end

    f.has_many :sellers_categories, heading: 'Categories', new_record: true, allow_destroy: true do |a|
      a.input :category
    end

    f.actions
  end

  controller do
    def update
      if params[:seller][:password].blank?
        params[:seller].delete("password")
      end
      super
    end
  end

end
