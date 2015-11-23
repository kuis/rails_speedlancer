json.result true
json.product do
	json.id @product.id
	json.title @product.title
	json.subheading @product.subheading.to_s
	json.price @product.price
	json.thumbnail image_path(@product.thumbnail)
	json.description simple_format(@product.description)
	json.category @product.category.name
	json.eta_from_now @product.eta_from_now

	if @product.custom_seller.nil? or @product.custom_company_name.blank? or @product.custom_company_logo.blank?
		json.custom_data nil
	else
		json.custom_data do
			json.seller do
				json.name @product.custom_seller.name
				json.avatar get_profile_image_url(@product.custom_seller)
			end
			json.company do
				json.name @product.custom_company_name
				json.logo image_path(@product.custom_company_logo)
			end
			json.result @product.custom_result.nil? ? nil : image_path(@product.custom_result)
		end
	end
end