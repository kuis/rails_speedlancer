ActiveAdmin.register Bundle do
	menu priority: 4

	filter :title
	filter :status

	form do |f|
		f.inputs "Details" do
			f.input :title
			f.input :description, :input_html => { :rows=>5 }
			f.input :price
			f.input :status, as: :select, collection: Product.statuses.keys
			f.input :thumbnail
			f.input :note
		end

		f.has_many :bundle_contents, heading: 'Bundle Contents', new_record: true, allow_destroy: true do |a|
			a.input :title
			a.input :thumbnail
			a.input :description, :input_html => { :rows=>3 }
		end

		f.actions
	end

	controller do
		def permitted_params
			params.permit!
		end
	end
end