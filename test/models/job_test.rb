require 'test_helper'

class JobTest < ActiveSupport::TestCase
  
  test "fixture is valid" do
    job = jobs(:paint)
    assert job.save
  end
  
  test "should not save job without a description" do
    job = jobs(:paint)
    job.description = nil
    assert_not job.save
  end
  
  test "should not save job without an item" do
    job = jobs(:paint)
    job.item_id = 100
    assert_not job.save
  end
  
end
