module ItemsHelper

  def nested_locations_json(locations)
    locations.map do |location, sub_locations|
        render partial: "item", locals:{location: location, sub_locations: sub_locations}      
    end.join(",").html_safe
  end
  
end
