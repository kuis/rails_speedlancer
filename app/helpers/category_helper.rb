module CategoryHelper

  def active_selected_category(category, params)
    if controller_name == "category"
      "active" if category.id.to_s == params[:id]
    end
  end

end
