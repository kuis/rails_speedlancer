class Seller < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Gravtastic
  gravtastic default: 'identicon'
  nilify_blanks :only => [:paypal_email]

  mount_uploader :avatar, AttachmentUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :paypal_email, :email_format => true, on: :update

  has_many :comments, as: :commentable
  has_many :messages, as: :messagable
  has_many :feedbacks
  # has_many :received_messages, :class_name => "Message", :as => :receiver

  has_many :sellers_tasks
  has_many :pay_outs
  has_many :accepted_tasks, through: :sellers_tasks, class_name: "Task", source: :task
  has_many :sellers_submissions
  has_many :submissions, through: :sellers_submissions
  has_many :sellers_categories
  has_many :categories, through: :sellers_categories
  has_many :categorised_tasks, through: :categories, class_name: "Task", source: :tasks

  scope :payble_seller, -> {where(" speedlancer_credits_in_cents > ? ", 1500 ).where("paypal_email IS NOT NULL")}
  scope :approved, -> {where(approved: true)}

  before_create :approve_seller
  # after_commit :notify_admin_about_new_seller, on: :create
  accepts_nested_attributes_for :sellers_categories, allow_destroy: true, reject_if: proc { |attributes| attributes['category_id'].blank? }

  # def self.search_credits
  #   _sellers = Seller.all.where(speedlancer_credits_in_cents: 1500..Float::INFINITY)
  # end

  def self.create_payouts
    payble_seller.find_each do |_seller|
      payout_params = {
        amount: _seller.speedlancer_credits_in_dollars,
        paypal_email: _seller.paypal_email,
        currency: "USD"
      }
      _payout = _seller.pay_outs.create(payout_params)
      if _payout.persisted?
        puts "New payout: Seller( #{_seller.id} ) ( #{_payout.id} amounted #{_payout.amount} )"
        _seller.reset_credits
      end
    end
  end

  def approve_seller
    self.assign_attributes(:approved => true, :approved_at => Time.zone.now)
  end

  def notify_and_approve_for_sales
    approve_seller
    self.save
    Notifier.send_sales_approved_email(self).deliver #if Rails.env.development?
  end

  def notify_seller_about_account_details(_password)
    Notifier.send_account_credentials_to_seller(_password, self).deliver
  end

  def block_for_sales
    self.update_attributes(:approved => false, :approved_at => nil)
    # Notifier.send_block_for_sales_email(self).deliver #if Rails.env.development?
  end

  def full_name
    name.present? ? name : email.email_to_name
  end

  def first_name_for_email
    (first_name.present? ? first_name : email.email_to_name).capitalize
  end

  def name
    (first_name.to_s + " " + last_name.to_s)
  end

  def first_name_n_last_initial
    first_name.present? ? (first_name + " " + last_name.try(:chr).to_s) : nil
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

  def add_credits(_credits_to_add)
    if _credits_to_add > 0.0
      self.speedlancer_credits_in_dollars = (speedlancer_credits_in_dollars + _credits_to_add)
      self.save
    end
  end

  def reset_credits
    self.update_attribute(:speedlancer_credits_in_cents, 0)
  end

  def average_rating
    ratings = feedbacks.pluck :rating
    average = ratings.sum / ratings.size.to_f unless ratings.blank?
    average = 0.0 if ratings.blank?
    average
  end

  ###################
  ## Devise Methods##
  ###################

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

end

# == Schema Information
#
# Table name: sellers
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
#  approved                     :boolean          default(FALSE), not null
#  approved_at                  :datetime
#  buyer_id                     :integer
#  speedlancer_credits_in_cents :integer          default(0)
#  avatar                       :string(255)
#  paypal_email                 :string(255)
#  first_name                   :string(255)
#  last_name                    :string(255)
#
