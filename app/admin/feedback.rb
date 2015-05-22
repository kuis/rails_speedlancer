ActiveAdmin.register Feedback do

  menu priority: 6
  permit_params :body, :rating

  # Index section
  filter :body, as: :string
  filter :rating, as: :numeric

  index do
    column "Id" do |feedback|
      link_to feedback.id, admin_feedback_path(feedback)
    end
    column :body do |feedback|
      truncate feedback.body
    end
    column :rating
  end

  # Show Section
  show do
    attributes_table do
      row :id
      row :body
      row :rating
      row :buyer
      row :seller
    end
  end

end


# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  body       :text
#  rating     :integer
#  buyer_id   :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  seller_id  :integer
#
