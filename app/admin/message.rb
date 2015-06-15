ActiveAdmin.register Message do

  menu priority: 7

  permit_params :content, :task_id, :messagable_id, :messagable_type

  # Index section
  filter :content, as: :string
  filter :task_id, as: :numeric

  index do
    column "Id" do |message|
      link_to message.id, admin_message_path(message)
    end
    column :content
    column :task
  end


end


# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  task_id         :integer
#  messagable_id   :integer
#  messagable_type :string(255)
#
