ActiveAdmin.register Product do
	menu priority: 3

	# permit_params :title, :subheading, :description, :price, :status, :category_id, :thumbnail, :note, :eta, :tags, :margin, :custom_company_name, :custom_company_logo, :custom_seller_id, :custom_result

	filter :category
	filter :title
	filter :status

	index do
		column :id
		column :title
		column :price
		column :margin
		column :status
		column :eta
		column :tags
		actions
	end

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

		f.inputs "Custom fields" do
			f.input :custom_company_name
			f.input :custom_company_logo
			f.input :custom_seller
			f.input :custom_result
		end

		f.actions
	end

	controller do
		def permitted_params
			params.permit!
		end
	end

	action_item :only => :index do
		link_to 'Upload CSV', :action => 'upload_csv'
	end

	collection_action :upload_csv do
		render "admin/csv/upload_csv"
	end

	collection_action :import_csv, :method => :post do
		CsvDb.convert_save("Product", params[:dump][:file])
		redirect_to :action => :index, :notice => "CSV imported successfully!"
	end
end