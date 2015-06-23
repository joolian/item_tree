class Item < ActiveRecord::Base
	has_one :location, dependent: :destroy, inverse_of: :item
	accepts_nested_attributes_for :location, allow_destroy: true, reject_if: :all_blank
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  
  def self.move_location(moved, moved_to)
  # Used in conjuction with jstree drag and drop. 'moved' is the item dragged and dropped.
  # 'moved_to' is the item dropped onto.
  # 'position' is the position relative to 'moved_to'.
    if moved then
      location_moved = Location.find(Item.find(moved).location)
      location_target = Location.find(Item.find(moved_to).location)
      new_parent_id = location_target.id
      if location_path_is_continuous(new_parent_id) then
      	location_moved.parent_id = new_parent_id
      	location_moved.save
      	return location_moved.parent_id
      end
    end
  end
  
  def self.location_path_is_continuous(new_parent_id)
    Location.find(new_parent_id).is_location ? true : false
  end
  
	def item_path
		self.location.path.map{ |ancestor|ancestor.item }
	end
  
end
