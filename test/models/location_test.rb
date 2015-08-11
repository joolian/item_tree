require 'test_helper'

class LocationTest < ActiveSupport::TestCase
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
  
  test "parent should not be a thing" do
    place = locations(:bathroom_place)
    thing = locations(:armchair_thing)   
    place.parent_id  = thing.id
    assert_not place.save
  end
  
  test "should not save location without an item" do
    place = @house_place
    place.item_id = 100
    assert_not place.save
  end
end
