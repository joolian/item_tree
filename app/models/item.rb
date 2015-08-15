class Item < ActiveRecord::Base
	has_one :location, dependent: :destroy, inverse_of: :item
  has_many :jobs
	accepts_nested_attributes_for :location, allow_destroy: true, reject_if: :all_blank
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  before_destroy :can_be_destroyed?

  delegate :is_location, :has_children?, :root?, to: :location, prefix: false
  
  #TODO
  # Add index to name
  
  def self.move_location(moved_id, moved_to_id)
  # Used in conjuction with jstree drag and drop. 'moved' is the item dragged and dropped.
  # 'moved_to' is the item dropped onto.
  # 'position' is the position relative to 'moved_to'.
    if moved_id
      location_moved = Item.find(moved_id).location
      new_parent_id = Item.find(moved_to_id).location.id
      location_moved.parent_id = new_parent_id
      location_moved.save ? true : false
    end
  end
  
  def self.root
    # The root item of the item tree.
    Location.roots.first.item
  end
  
  def self.get_locations(item, show_root)
    if show_root
      locations = []
      locations << item.location
    else
      locations = item.children
    end  
  end
  
  def self.text_search(query)
    Location.location_tree.where( "items.name ilike :q", q: "%#{query}%"  ).references(:items)
  end
  
  def parent_item
    # The parent item of the item.
    self.location.parent.item if self.location.parent
  end
  
  def children
    # Returns all the child locations of an item, including the items.
    self.location.children.location_tree
  end

  def item_path
    # Returns the path to root as an array of items.
    self.location.path.location_tree.map{ |ancestor|ancestor.item }
  end
  
  def item_type
  	if self.root?
  		return "organisation"
  	else
  		return self.is_location ? "location" : "thing"
  	end
  end

  
  private
  def can_be_destroyed?
    # Can't delete the root node.
    self.root? ? false : true    
  end

end
