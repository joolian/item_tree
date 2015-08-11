require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  def setup
    
    @house_place = locations(:house_place) #root
    
    @hall_place = locations(:hall_place) #house>hall
    @hall_place.parent_id = @house_place.id
    @hall_place.save
    
    @bathroom_place = locations(:bathroom_place) #house>hall>bathroom
    @bathroom_place.parent_id = @hall_place.id
    @bathroom_place.save
    
    @lounge_place = locations(:lounge_place) #house>hall>lounge
    @lounge_place.parent_id = @hall_place.id
    @lounge_place.save
    
    @armchair_thing = locations(:armchair_thing) #house>hall>lounge>armchair
    @armchair_thing.parent_id = @lounge_place.id
    @armchair_thing.save
    
    @umbrella_thing = locations(:umbrella_thing) #gouse>hall>umbrella
    @umbrella_thing.parent_id = @hall_place.id
    @umbrella_thing.save
    
    @garden_place = locations(:garden_place) #house>garden
    @garden_place.parent_id = @house_place.id
    @garden_place.save
    
  end
  
  def teardown
    @house_place = nil
    @hall_place = nil
    @bathroom_place = nil
    @lounge_place = nil
    @armchair_thing = nil
    @umbrella_thing = nil
    @garden_place = nil
  end
  
  test "should not save item without a name" do
    item = items(:house)
    item.name = nil
    assert_not item.save
  end
  test "should not save item without a code" do
    item = items(:house)
    item.code = nil
    assert_not item.save
  end
  test "should not save item with a code that is not unique, case insensitive" do
    item = items(:house)
    other_item = items(:hall)
    item.code = other_item.code.upcase
    assert_not item.save
  end
  test "should not save an item who's parent is not a location unless it is the root item" do
    root_item = items(:house)
    item = items(:bathroom)
    thing_item = items(:umbrella)
    item.location.parent_id = thing_item.location.id
    assert_not item.save, "Saved an item who's parent is a thing"
    assert root_item.save, "Did not save the root item"
  end
  test "root should return the root item" do
    assert_equal Item.root.id, @house_place.item.id, "Did not return the root item"
    assert_not_equal Item.root.id, @lounge_place.item.id, "Returned the wrong item as the root item"
  end
  test "parent_item returns the items parent or nil if no parent" do
    thing = items(:bathroom)
    thing_parent = items(:hall)
    assert_equal thing.parent_item.id, thing_parent.id
  end
  test "children returns a collection of the children" do
    
  end
  test "item_path should return the path to the root as an array of items" do
    
  end
  test "can_be_destroyed should return true for a childless item" do
    
  end
end
