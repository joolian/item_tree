class Item < ActiveRecord::Base
	has_one :location, dependent: :destroy, inverse_of: :item
  has_many :jobs
	accepts_nested_attributes_for :location, allow_destroy: true, reject_if: :all_blank
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  
  #TODO
  # Need a validation so that an item that is a location cannot be changed to a thing if it has children.
  # Add indxes to name and code
  
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
    #the root item of the locations tree
    Location.roots.first.item
  end

  def self.text_search(query)
    Location.location_tree.where( "items.name ilike :q", q: "%#{query}%"  ).references(:items)
  end

  def parent_item
    self.location.parent.item if self.location.parent
  end

  def children
    # Returns all the child locations of an item, including the items
    self.location.children.location_tree
  end

  def item_path
    # Returns
    self.location.path.location_tree.map{ |ancestor|ancestor.item }
  end

  def can_be_destroyed
    # TODO this is unnecessary if set ancestry options to :orphan_strategy is :restrict
    # TODO test for the root node: can't delete that
    self.location.is_childless? ? true : false
  end

end
