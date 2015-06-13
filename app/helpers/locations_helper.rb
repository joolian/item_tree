module LocationsHelper
  def nested_locations(locations)
  	locations.map do |location, sub_locations|
  		id_tag = location.item.id
      if location.is_location then
  			type = "location"
  		else
  			type = "thing"
  		end
  		if !sub_locations.empty? then
  			content_tag(:li,render(location.item) + content_tag(:ul, nested_locations(sub_locations)), id: id_tag, data: {jstree:  {type: type}})
  		else
  				content_tag(:li, render(location.item), id: id_tag, data: {jstree: {type: type}})
  		end
  	end.join.html_safe
  end
end