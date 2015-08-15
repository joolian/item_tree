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
    
    @house = items(:house)
    @hall = items(:hall)
    @bathroom = items(:bathroom)
    @lounge = items(:lounge)
    @armchair = items(:armchair)
    @umbrella = items(:umbrella)
    @garden = items(:garden)
    
  end
  
  def teardown
    @house_place = nil
    @hall_place = nil
    @bathroom_place = nil
    @lounge_place = nil
    @armchair_thing = nil
    @umbrella_thing = nil
    @garden_place = nil
    @house = nil
    @hall = nil
    @bathroom = nil
    @lounge = nil
    @armchair = nil
    @umbrella = nil
    @garden = nil    
  end
  
  test "should not save item without a name" do
    @house.name = nil
    assert_not @house.save
  end
  
  test "should not save item without a code" do
    @house.code = nil
    assert_not @house.save
  end
  
  test "should not save item with a code that is not unique, case insensitive" do
    @house.code = @hall.code.upcase
    assert_not @house.save
  end
  
  test "should not save an item who's parent is not a location unless it is the root item" do
    @bathroom.location.parent_id = @umbrella.location.id
    assert_not @bathroom.save, "Saved an item who's parent is a thing"
    assert @house.save, "Did not save the root item"
  end
  
  test "root should return the root item" do
    assert_equal Item.root.name, @house_place.item.name, "Did not return the root item"
    assert_not_equal Item.root.name, @lounge_place.item.name, "Returned the wrong item as the root item"
  end
  
  test "parent_item returns the items parent or nil if no parent" do
    assert_equal @bathroom.parent_item.id, @hall.id    
  end
  
  test "children returns a collection of the children" do
    assert_includes @house.children, @hall.location
    assert_includes @house.children, @garden.location
  end
  
  test "item_path should return the path to the root as an array of items" do
    true_path = []
    true_path << @house.id
    true_path << @hall.id
    true_path << @lounge.id
    true_path << @armchair.id
    true_path = true_path.join("_")
    item_path = @armchair.item_path.map{|i| i.id}.join("_")
    assert_equal true_path, item_path
  end
  
  test "can_be_destroyed? should return true for a childless item" do
    @garden.location.parent_id = nil
    assert_not @garden.destroy
  end
  
  test "delegate for is_location should match location.is_location" do
    assert @house.is_location, @house.location.is_location
  end
  
  test "delegate has_children? should match location.has_children?" do
    assert @house.has_children?, @house.location.has_children?
  end
  
  test "delegate for root? should match location.root?" do
    assert @house.location.root?, @house.root?
  end
  
  test "item_type should return the correct type" do
    assert "organisation", @house.item_type
    assert "location", @lounge.item_type
    assert "thing", @umbrella.item_type
  end
  
  test "tree locations should return child locations when show_root is false" do
    assert_includes Item.get_locations(@house, false), @hall_place
    assert_includes Item.get_locations(@house, false), @garden_place
  end
  
  test "tree locations should return the items location when show_root is true" do
    assert_includes Item.get_locations(@house, true), @house_place
    assert Item.get_locations(@house, false).length, 1
  end
end
