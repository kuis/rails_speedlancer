module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
   link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def link_to_function(name, *args, &block)
    html_options = args.extract_options!.symbolize_keys

    function     = block_given? ? update_page(&block) : args[0] || ''
    onclick      = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href         = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def display_profile_image(_resource)
    if _resource.avatar?
      image_tag _resource.avatar_url, class: "com-img"
    else
      image_tag _resource.gravatar_url, class: "com-img"
    end
  end

  def get_profile_image_url(_resource)
    _resource.avatar? ? _resource.avatar_url : _resource.gravatar_url
  end

  def side_bar_present?
    if current_buyer_or_seller.present?
      if controller_name == "tasks" and ["edit", "update", "create", "new"].include?action_name
        false
      elsif controller_name == "registrations" and ["edit", "update"].include?action_name
        false
      elsif controller_name == "buyers" and ["team", "subscribe"].include?action_name
      else
        true
      end
    else
      false
    end
  end

end
