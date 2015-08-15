json.array! @locations.map{|location| location.item} do |item|
	json.id item.id
	json.text item.name
	json.type item.item_type
	json.a_attr do
		json.href item_path(id: item.id)
	end
	json.children item.has_children?
end