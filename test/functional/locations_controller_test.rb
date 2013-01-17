require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get pick" do
    get :pick
    assert_response :success
  end

end
