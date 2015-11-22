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
end