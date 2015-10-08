ActiveAdmin.register Team do
	permit_params :package_id, :deadline, :members, :status, :buyer_id

	form do |f|
		f.inputs "Details" do
			f.input :buyer
			f.input :package
			f.input :deadline
			f.input :members
			f.input :status, as: :select, collection: Team.statuses.keys
		end
		f.actions
	end
end