ActiveAdmin.register Bundle do
	menu priority: 3

	permit_params :title, :description, :status, :category_id, :thumbnail

	filter :category
	filter :title
	filter :status

	form do |f|
		f.inputs "Details" do
			f.input :category
			f.input :title
			f.input :description, as: :text
			f.input :status, as: :select, collection: Product.statuses.keys
			f.input :thumbnail
		end

		f.actions
	end
end