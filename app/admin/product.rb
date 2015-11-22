ActiveAdmin.register Product do
	menu priority: 3

	permit_params :title, :subheading, :description, :price, :status, :category_id, :thumbnail, :note, :eta, :tags, :margin

	filter :category
	filter :title
	filter :status

	form do |f|
		f.inputs "Details" do
			f.input :category
			f.input :title
			f.input :subheading
			f.input :description, input_html: {rows: "5"}
			f.input :price
			f.input :margin
			f.input :eta, label: "ETA hours"
			f.input :status, as: :select, collection: Product.statuses.keys
			f.input :thumbnail
			f.input :note, input_html: {rows: "3"}
			f.input :tags
		end

		f.actions
	end
end