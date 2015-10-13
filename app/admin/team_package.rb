ActiveAdmin.register TeamPackage do

  menu priority: 2

  permit_params :title, :cycle, :cost_in_dollars, :members

  # Index section
  filter :title

  index do
    column :id
    column "Title" do |p|
      link_to p.title, admin_team_package_path(p)
    end
    column :cycle
    column :members
    column "Cost" do |package|
      number_to_currency (package.cost_in_dollars)
    end
    # actions
  end

  # Show Section
  show do
    attributes_table do
      row :title
      row :cycle
      row :members
       row "cost", :cost_in_dollars do |p|
        number_to_currency (p.cost_in_dollars)
      end
      row :created_at
    end
  end

  # form section

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :cost_in_dollars, :label => "Cost"
      f.input :members
      f.input :cycle
    end

    f.actions
  end

end
