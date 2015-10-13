ActiveAdmin.register Buyer do

  menu priority: 2

  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :about, :speedlancer_credits_in_dollars, :avatar

  # Index section
  filter :email, as: :string
  filter :first_name, as: :string
  filter :last_name, as: :string

  index do
    column :id
    column "Email" do |buyer|
      link_to buyer.email, admin_buyer_path(buyer)
    end
    column :first_name
    column :last_name
    column "Credits" do |buyer|
      number_to_currency (buyer.speedlancer_credits_in_dollars)
    end
  end

  # Show Section
  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :sign_in_count
      row :about
       row "Credits", :speedlancer_credits_in_dollars do |buyer|
        number_to_currency (buyer.speedlancer_credits_in_dollars)
      end
      row :created_at
    end

    if buyer.tasks.present?
      panel "Buyers Tasks" do
        table_for buyer.tasks.active do
          column "Active Tasks(#{buyer.tasks.active.count})" do |task|
            link_to task.title, admin_task_path(task)
          end
        end
        table_for buyer.tasks.lapse do 
          column "Lapsed Tasks(#{buyer.tasks.lapse.count})" do |task|
            link_to task.title, admin_task_path(task)
          end
        end


        table_for buyer.tasks.progress_or_review do
          column "Tasks in Progress(#{buyer.tasks.progress_or_review.count})" do |task|
            link_to task.title, admin_task_path(task)
          end
        end

        table_for buyer.tasks.completed do
          column "Completed Tasks(#{buyer.tasks.completed.count})" do |task|
            link_to task.title, admin_task_path(task)
          end
        end
      end
    end
  end

  collection_action :restart_all_bots, method: :get do
    _buyers = Buyer.where("(bot_key IS NOT NULL AND bot_key!='') OR (bot_pid IS NOT NULL AND bot_pid!='')")

    for _buyer in _buyers
      unless _buyer.bot_pid.blank?
        _buyer.kill_bot
      end
      unless _buyer.bot_key.blank?
        _buyer.create_bot
      end
      _buyer.save
    end

    redirect_to collection_path
  end

  member_action :restart_bot, method: :get do
    redirect_to "#{collection_path}/#{resource.id}"
    unless resource.bot_pid.blank?
      resource.kill_bot
    end
    unless resource.bot_key.blank?
      resource.create_bot
    end
      resource.save
  end

  action_item :view, only: :show do
    unless resource.team.nil?
      link_to "#{resource.first_name}'s Team", admin_team_path(resource.team)
    end
  end

  action_item :view, only: :show do
    unless resource.bot_key.blank?
      link_to "Restart bot", "#{collection_path}/#{resource.id}/restart_bot"
    end
  end

  action_item :view, only: :show do
    link_to 'Login as Buyer', sign_in_as_buyer_path(buyer_id: resource.id), :target => "_blank"
  end

  action_item :view, only: :index do
    _buyers = Buyer.where("bot_key IS NOT NULL AND bot_key!=''")
    link_to "Restart #{_buyers.count} #{'bot'.pluralize(_buyers.count)}", "#{collection_path}/restart_all_bots"
    # '/admin/buyers/restart_all_bots'
  end

  # form section

  form do |f|
    f.inputs "Details" do
      f.input :email, label: "Buyer Email"
      f.input :password
      f.input :first_name, label: "First Name"
      f.input :last_name, label: "Last Name"
      f.input :about
      f.input :speedlancer_credits_in_dollars, label: "Credits"
      f.input :avatar
    end

    f.actions
  end

  controller do
    def update
      if params[:buyer][:password].blank?
        params[:buyer].delete("password")
      end
      super
    end
  end

  csv do
    column :id
    column :email
    column(:name) { |buyer| buyer.name }
    # column(:confirmed_at) { |buyer| buyer.confirmed_at.to_i }
    column(:confirmed_at) { |buyer| buyer.confirmed_at.to_i }
    column(:last_sign_in_at) { |buyer| buyer.last_sign_in_at.to_i }
    # column :speedlancer_credits_in_cents
    column(:speedlancer_credits_in_dollars) { |buyer| buyer.speedlancer_credits_in_dollars.to_s }
    column :avatar
    column :bot_key
  end

end


# == Schema Information
#
# Table name: buyers
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  about                  :text
#  created_at             :datetime
#  updated_at             :datetime
#
