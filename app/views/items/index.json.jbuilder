json.array! @locations do |location|
	if location.parent_id then
		type = location.is_location ? "location" : "thing"
	else
		type = "organisation"
	end
	json.id location.item.id
	json.text location.item.name
	json.type type
	json.a_attr do
		json.href item_path(id: location.item.id)
	end
	json.children location.has_children?
end