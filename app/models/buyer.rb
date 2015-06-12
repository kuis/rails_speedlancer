class Buyer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :credits_to_add

  include Paypal
  include Gravtastic
  gravtastic default: 'identicon'

  mount_uploader :avatar, AttachmentUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :tasks
  has_many :comments, as: :commentable
  has_many :feedbacks
  has_many :messages, as: :messagable
  has_many :payment_notifications
  # has_many :received_messages, :class_name => "Message", :as => :receiver

  validates :bot_key, uniqueness: true

  before_save :check_bot_key_changes

  def self.get_buyer_for_api(buyer_params)
    _buyer = nil
    if buyer_params[:bot_key].present?
      _buyer = find_by bot_key: buyer_params[:bot_key]
    else
      _buyer = find_or_initialize_by email: buyer_params[:email]
      if _buyer.new_record?
        _buyer.name = buyer_params[:name]
        _buyer.skip_confirmation_notification!
        _buyer.password = Devise.friendly_token.first(8)
        _buyer.save
      end
    end
    return _buyer
  end

  def full_name
    name.present? ? name : email.email_to_name
  end

  def first_name_for_email
    (first_name.present? ? first_name : email.email_to_name).capitalize
  end

  def first_name_n_last_initial
    first_name.present? ? (first_name + " " + last_name.try(:chr).to_s) : nil
  end

  def name
    (first_name.to_s + " " + last_name.to_s)
  end

  def name=(name)
    self.first_name, self.last_name = name.split(" ") if name.present?
  end

  def has_credits?
    (speedlancer_credits_in_cents.present? ? ((speedlancer_credits_in_cents > 0) ? true : false) :false)
  end

  def speedlancer_credits_in_dollars
    speedlancer_credits_in_cents.to_d / 100 if speedlancer_credits_in_cents
  end

  def speedlancer_credits_in_dollars=(dollars)
    self.speedlancer_credits_in_cents = dollars.to_d * 100 if dollars.present?
  end

  def deduct_credits(_credits_to_deduct)
    if _credits_to_deduct > 0.0
      self.speedlancer_credits_in_dollars = (speedlancer_credits_in_dollars - _credits_to_deduct)
      self.save
    end
  end

  def add_credits(_credits_to_add)
    if _credits_to_add > 0.0
      self.speedlancer_credits_in_dollars = (speedlancer_credits_in_dollars + _credits_to_add)
      self.save
    end
  end

  def check_status_and_add_credits(_params)
    if _params[:payment_status] == "Completed"
      _credits_to_add = (_params[:mc_gross]).to_f
      add_credits(_credits_to_add)
    end
  end

  def confirm_and_send_credentials
    unless confirmed?
      _password = Devise.friendly_token.first(8)
      self.password = _password
      self.confirmation_token =  nil
      self.confirmed_at = Time.zone.now
      self.confirmation_sent_at = nil
      self.save
      Notifier.delay.send_account_credentials_to_buyer(_password, self)
    end
  end

  def check_bot_key_changes
    if bot_key_changed?
      if bot_key.present? and bot_key_was.blank?
        create_bot
      elsif bot_key.present? and bot_key_was.present?
        kill_bot
        create_bot
      elsif bot_key.blank?  and bot_key_was.present?
        kill_bot
      end
    end
  end

  def create_bot
    # pid = fork {  exec 'node', 'bin/bot.js', bot_key}
    pid = fork {  exec 'node', 'slack-bot/bot_test/firstbot.js', bot_key}
    logger.info "#############"
    logger.info "New bot #{pid}"
    logger.info "#############"
    self.bot_pid = pid
  end

  def kill_bot
    kill_command = "kill -9 " + bot_pid
    fork {  exec kill_command }
    logger.info "####################"
    logger.info "Killed bot #{bot_pid}"
    logger.info "####################"
    self.bot_pid = nil
  end

end

# == Schema Information
#
# Table name: buyers
#
#  id                           :integer          not null, primary key
#  email                        :string(255)
#  encrypted_password           :string(255)      default(""), not null
#  reset_password_token         :string(255)
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string(255)
#  last_sign_in_ip              :string(255)
#  about                        :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  confirmation_token           :string(255)
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  speedlancer_credits_in_cents :integer          default(0)
#  avatar                       :string(255)
#  first_name                   :string(255)
#  last_name                    :string(255)
#  active                       :boolean          default(FALSE)
#  bot_key                      :string(255)
#  bot_pid                      :string(255)
#
