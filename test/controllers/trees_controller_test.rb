require 'test_helper'

class TreesControllerTest < ActionController::TestCase
  test "should get basic_html" do
    get :basic_html
    assert_response :success
  end

end
