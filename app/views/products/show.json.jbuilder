json.result true
json.product do
	json.id @product.id
	json.title @product.title
	json.price @product.price
	json.thumbnail image_path(@product.thumbnail)
	json.description @product.description
	json.category @product.category.name
end