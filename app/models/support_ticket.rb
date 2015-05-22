class SupportTicket < ActiveRecord::Base

  validates :email, :content, presence: true

  after_create :send_email_to_admin, on: :commit

  def send_email_to_admin
  	Notifier.send_support_ticket_email(self).deliver #if Rails.env.production?
  end
  handle_asynchronously :send_email_to_admin


end

# == Schema Information
#
# Table name: support_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#
