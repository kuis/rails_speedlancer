class Task < ActiveRecord::Base

  default_scope { order('created_at DESC') }

  validates :title, :description, :category_id, :buyer_id, presence: true
  validates :price_in_dollars, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0.01}
  validates_associated :category

  belongs_to :buyer
  belongs_to :category
  belongs_to :present_seller, :foreign_key => "present_seller_id", :class_name => "Seller"
  has_one  :feedback, dependent: :destroy
  has_one  :payment_summary, dependent: :destroy
  has_many :sellers_tasks, -> { uniq }
  has_many :sellers, through: :sellers_tasks
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :payment_notifications, dependent: :destroy
  has_many :task_attachments, dependent: :destroy
  has_many :sellers_submissions
  has_many :submissions, through: :sellers_submissions
  has_many :submission_attachments, through: :sellers_submissions
  has_many :notes, dependent: :destroy
  accepts_nested_attributes_for :notes, allow_destroy: true

  enum status: [ :active, :in_progress, :in_review, :completed, :inactive, :lapse]
  # Status =>
    # 0 => active, 1 => in_progress,
    # 2 => in_review, 3 => completed,
    # 4 => inactive, 5 => lapse
  scope :progress_or_review, -> {in_review | in_progress}
  scope :lapse_or_inactive, -> {lapse | inactive}
  scope :available_tasks, -> {where(status: 0, present_seller_id: nil)}

  accepts_nested_attributes_for :task_attachments, reject_if: :check_file_blank?,  :allow_destroy => true
  accepts_nested_attributes_for :feedback

  after_commit :background_processing, on: :create

  serialize :watchers

  def self.tasks_lapse
    lapse_task_array = []
    Task.active.find_each do |task|
      if (task.activated_at.present?) and (task.activated_at < 8.hours.ago)
        puts "'#{task.title}' has been lapsed!"
        lapse_task_array << task
        task.lapse!
        task.refund_credits(task.buyer)
        Notifier.delay.send_task_lapse_email(task)
      end
    end
    Notifier.delay.send_task_lapse_email_to_admin(lapse_task_array).deliver if lapse_task_array.size > 0
  end

  def self.check_task_time_out
    _tasks = Task.in_progress.where(deadline: 3.hours.ago..(Time.zone.now))
    if _tasks.present?
      Notifier.send_task_time_run_out_to_admin_email(_tasks).deliver
    end
    _tasks.each do |task|
      Notifier.delay.send_task_time_run_out_to_seller_email(task)
    end
  end

  def background_processing
    self.create_payment_summary!
  end

  def new_task_create_email
    _category = self.category
    _category.sellers.each do |seller|
      Notifier.send_notify_sellers_about_new_tasks_email(category, seller, self).deliver
    end
  end
  handle_asynchronously :new_task_create_email

  def create_attachments(_attachments_params)
    puts "attachment ++++ "
    puts _attachments_params
    if _attachments_params.present?
      _attachments_params.each do |key, attachment|
        task_attachments.create(remote_attachment_file_url: attachment)
      end
    end
  end

  def self.build_with_default_price
    self.new(price_in_dollars: 39)
  end

  def refund_credits(_buyer)
    lapse!
    _buyer.add_credits(price_in_dollars)
  end

  def watchers_count
    watchers.present? ? watchers.count : 0
  end

  def add_watcher(_seller_id)
    if watchers.present?
      self.watchers << _seller_id unless watchers.include? _seller_id
    else
      self.watchers = [_seller_id]
    end
    self.save
  end

  def remove_watcher(_seller_id)
    if watchers.present?
      watchers.delete(_seller_id)
      self.save
    end
  end

  def check_file_blank?(task_attachments_attributes)
    if task_attachments_attributes[:attachment_file].blank?
      return true
    end
  end

  def price_in_dollars
    price_in_cents.to_d / 100 if price_in_cents
  end

  def price_in_dollars=(dollars)
    self.price_in_cents = dollars.to_d * 100 if dollars.present?
  end

  def seller_price_in_cents
    (price_in_cents * (100 - fee_by_percent) / 100).to_i
    # (price_in_dollars * 0.8).to_d
  end

  def seller_pice_in_dollars
    (price_in_dollars * (100 - fee_by_percent) / 100).to_d
    # (price_in_dollars * 0.8).to_d
  end

  def progress_or_review?
    in_progress? or in_review?
  end

  def lapse_or_inactive?
    lapse? or inactive?
  end

  def move_back_to_que!
    _seller = self.present_seller
    Notifier.send_task_back_to_que_seller_email(self, _seller).deliver
    active!
    sellers_tasks.destroy_all
    sellers_submissions.destroy_all
    comments.destroy_all
    messages.destroy_all
    self.update_attributes(present_seller_id: nil, deadline: nil, activated_at: Time.zone.now, accepted_at: nil )
  end

  def progress_percentage
    if active?
      _percent = "0"
    elsif lapse_or_inactive?
      _percent = "0"
    elsif progress_or_review?
      _percent = "50"
    elsif completed?
      _percent = "100"
    end
    "width:" + _percent + "%"
  end

  def create_sellers_submission_for_seller(_params, _seller, _task)
    _submission = sellers_submissions.build(_params)
    _submission.seller_id = _seller.id
    if _submission.save
      _task.in_review!
      _submitted = true
    else
      _submitted = false
    end
    return _submission, _submitted
  end

  def update_on_acceptance!(_seller)
    self.status = "in_progress"
    self.accepted_at = Time.zone.now
    self.deadline = (Time.zone.now + 4.hours)
    self.present_seller_id = _seller.id
    self.save
    _seller.sellers_tasks.create(task_id: id)
    notify_buyer_task_accepted_by_seller
  end

  def paypal_url(return_path, required_credits, buyer_credits_to_remove, from_api=false)
    # on0..on9 are the optional parameters  name that paypal provide
    # os0..os9 are values of optional variables.
    # os0 is used for the passing the buyer credits to be removed.
    # os1 is used for the passing the call is from API i.e speedlancer.com wordpress app.

    values = {
      business: ENV["PAYPAL_MERCHANT_ACCOUNT"],
      cmd: "_xclick",
      upload: 1,
      # return: "#{return_path}",
      invoice: "#{self.id}-#{self.updated_at}".parameterize,
      item_name: self.title,
      item_number: self.id,
      amount: required_credits,
      # notify_url: "#{Rails.application.secrets.app_host}/hook",
      on0: "buyer_credits_to_remove",
      os0: buyer_credits_to_remove,
      page_style: "Speedlancer",
      on1: "from_api",
      os1: from_api
    }

    notify = {
      notify_url: "#{Rails.application.secrets.app_host}/hook"
    }

    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + notify.to_query + "&" + values.to_query
  end

  def payment_url(return_path, required_credits, buyer_credits_to_remove, from_api=false)
    if self.payment_method == "paypal"
      self.paypal_url(return_path, required_credits, buyer_credits_to_remove, from_api)
    elsif self.payment_method == "stripe"
      return_path
    else
      self.paypal_url(return_path, required_credits, buyer_credits_to_remove, from_api)
    end
  end

  def update_after_payment(_params)
    paypal_price_in_dollars = _params[:mc_gross].to_f
    buyer_credits = _params[:option_selection1].to_f
    status = _params[:payment_status]
    if status == "Completed"
      if self.active?
        self.price_in_dollars = self.price_in_dollars + paypal_price_in_dollars + buyer_credits
      else
        self.new_task_create_email if self.activated_at.blank?
        self.status         = "active"
        self.activated_at   = Time.zone.now
        self.buyer.confirm_and_send_credentials if _params[:option_selection2] == "true"
      end
      self.save
      self.buyer.deduct_credits(buyer_credits)
      payment_summary.update_buyer_values(paypal_price_in_dollars, buyer_credits) if payment_summary.present?
    end
  end

  def activate_n_deduct_credit_from_buyer(_task_price)
    self.new_task_create_email if self.activated_at.blank?
    self.activated_at = Time.zone.now
    self.status = "active"
    self.save
    buyer.deduct_credits(_task_price)
    payment_summary.update_buyer_values(0, _task_price) if payment_summary.present?
  end

  def build_feedback_with_buyer_seller(_params, _buyer, _seller)
    _feedback = self.build_feedback(_params)
    _feedback.assign_attributes( seller_id: _seller.id, buyer_id: _buyer.id,)
    return _feedback
  end

  def notify_buyer_task_accepted_by_seller
    _seller = present_seller
    _buyer = buyer
    Notifier.send_task_accepted_email(self, _buyer, _seller).deliver
  end
  handle_asynchronously :notify_buyer_task_accepted_by_seller

end



# == Schema Information
#
# Table name: tasks
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  description            :text
#  price_in_cents         :integer          default(0)
#  buyer_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#  category_id            :integer
#  status                 :integer          default(4)
#  comments_count         :integer          default(0)
#  present_seller_id      :integer
#  task_attachments_count :integer          default(0)
#  deadline               :datetime
#  activated_at           :datetime
#  watchers               :text
#  accepted_at            :datetime
#  delivered_at           :datetime
#  payment_method         :string(255)      default("paypal")
#  source                 :string(255)      default("wordpress")
#
