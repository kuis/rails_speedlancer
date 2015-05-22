ActiveAdmin.register SupportTicket do

  menu false

  permit_params :name, :email, :content

  # Index section
  index do
    column :id
    column "Email" do |support_ticket|
      link_to support_ticket.email, admin_support_ticket_path(support_ticket)
    end
    column :content do |support_ticket|
      truncate support_ticket.content
    end
  end

  # Show Section
  show do
    attributes_table do
      row :email
      row :name
      row :content
    end
  end

end
