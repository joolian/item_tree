module ItemsHelper

  def nested_locations_json(locations)
    locations.map do |location, sub_locations|
        render partial: "item", locals:{location: location, sub_locations: sub_locations}      
    end.join(",").html_safe
  end
  
  def nested_locations_html(locations)
  	locations.map do |location, sub_locations|
  		id_tag = location.item.id
      if location.is_location then
  			type = "location"
  		else
  			type = "thing"
  		end
  		if !sub_locations.empty? then
  			content_tag(:li,render(location.item) + content_tag(:ul, nested_locations_html(sub_locations)), id: id_tag, data: {jstree:  {type: type}})
  		else
  				content_tag(:li, render(location.item), id: id_tag, data: {jstree: {type: type}})
  		end
  	end.join.html_safe
  end
end
