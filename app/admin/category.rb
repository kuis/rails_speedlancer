ActiveAdmin.register Category do

  menu priority: 8

  permit_params :name

  index do
    column :id
    column "Name" do |category|
      link_to category.name, admin_category_path(category)
    end
  end

  # Show Section
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    if category.sellers.present?
      panel "Sellers" do
        table_for category.sellers do
          column "Id" do |seller|
            link_to seller.id, admin_seller_path(seller)
          end
          column :email
          column :speedlancer_credits_in_dollars
        end
      end
    end
  end

end
