  ActiveAdmin.register Task do

  menu priority: 4

  # Using params.permit!
  # permit_params :title, :description, :price_in_cents, :buyer_id, :category_id

  # Index section
  filter :id, as: :numeric
  filter :title, as: :string
  filter :description, as: :string
  filter :price_in_cents, as: :numeric
  filter :buyer, as: :select

  scope :active
  scope :in_progress
  scope :in_review
  scope :completed
  scope :inactive
  scope :lapse

  index do
    column :id
    column "Title" do |task|
      link_to task.title, admin_task_path(task)
    end
    column :description
    column :price_in_dollars, :sortable => :price_in_dollars do |task|
      number_to_currency (task.price_in_dollars)
    end
    column "Fee" do |task|
      task.fee_by_percent
    end

    column "Buyer's email", :buyer do |task|
      task.buyer.email if task.buyer.present?
    end
    column :present_seller
    column "Seller's email", :present_seller do |task|
      task.present_seller.email if task.present_seller_id?
    end
  end

  # CSV customization
  csv do
    column :id
    column :title
    column("Task Link") {|task| admin_task_url(task)}
    column :description
    column :price_in_cents
    column("Buyer's id") {|task| task.buyer.id if task.buyer.present?}
    column("Buyer's email") {|task| task.buyer.email if task.buyer.present?}
    column :created_at
    column :updated_at
    column :activated_at
    column :delivered_at
    column :comments_count
    column :task_attachments_count
    column("Dealine") {|task| task.deadline if task.deadline.present?}
    column("Category") {|task| task.category.name}
    column("Price in Dollars") {|task| number_to_currency (task.price_in_dollars)}
    column("Buyer's email") {|task| task.buyer.email if task.buyer.present?}
    column("Seller's email") {|task| task.present_seller.email if task.present_seller_id?}
  end

  # Show Section
  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :status
      row :buyer
      row "Buyer's email", :buyer do |task|
        task.buyer.email
      end
      row :category
      row :deadline
      row :accepted_at
      row :delivered_at
      row "Price", :price_in_dollars do |task|
        number_to_currency (task.price_in_dollars)
      end
      row :present_seller
      row "Seller's email", :present_seller do |task|
        task.present_seller.email if task.present_seller_id?
      end
      row :created_at
      row :updated_at
    end

    if task.feedback.present?
      panel "Feedback" do
        table_for task.feedback do
          column :body
          column :rating
        end
      end
    end

    if task.task_attachments.present?
      panel "Task Attachments" do
        table_for task.task_attachments do |task_attachment|
          column(:attachment_file) {|task_attachment| link_for_task_attachment_according_to_extention(task, task_attachment)}
        end
      end
    end

    if task.submission_attachments.present?
      panel "Submissions Attachments" do
        table_for task.submission_attachments do |submission_attachment|
          column(:submission) {|submission_attachment| link_for_sellers_submissions_according_to_extention(submission_attachment.sellers_submission, submission_attachment)}
        end
      end
    end

    if task.messages.present?
      panel "Personal Messages" do
        table_for task.messages do
          column :content
          column "Sender", :messagable
        end
      end
    end

    if task.comments.present?
      panel "Comments" do
        table_for task.comments do |comment|
          column :body
          column "Commentor", :commentable
          column do |comment|
            link_to "Delete Comment", delete_comment_admin_task_path(comment_id: comment.id), method: :delete
          end
        end
      end
    end

    if task.notes.present?
      panel "Notes" do
        table_for task.notes do
          column :content
        end
      end
    end

    if task.payment_summary.present? and !(["inactive", "lapse"].include? task.status)
      panel "Payment Summary" do
        table_for task.payment_summary do
          column :total_payment
          column :credits_used
          column :paypal_part
          column :seller_credits if task.completed?
        end
      end
    end

  end

  member_action :refund_credits, :method => :get do
    _task = Task.find(params[:id])
    _task.refund_credits(_task.buyer)
    redirect_to resource_path(_task),  notice: "Task refunded"
  end

  member_action :delete_comment, :method => :delete do
    _comment = Comment.find(params[:comment_id])
    _task = _comment.task
    _comment.destroy
    redirect_to resource_path(_task),  notice: "Comment deleted"
  end

  action_item :view, only: :show do
    if ["active", "in_progress", "in_review"].include? resource.status
      link_to 'Refund task', refund_credits_admin_task_path(resource)
    end
  end

  # form section

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :category
      f.input :description
      f.input :price_in_dollars
      f.input :deadline
      f.input :status, as: :select, collection: Task.statuses.keys
      f.has_many :task_attachments, heading: 'Attachments', new_record: true, allow_destroy: true do |a|
        a.input :attachment_file
      end
      f.inputs "Feedback", for: [:feedback, f.object.feedback] do |fd|
        fd.input :body
        fd.input :rating
      end
      f.has_many :notes, heading: "Notes", new_record: true, allow_destroy: true do |n|
        n.input :content
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end


end


