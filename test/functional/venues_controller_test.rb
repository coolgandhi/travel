require 'test_helper'

class VenuesControllerTest < ActionController::TestCase
  test "should get pick" do
    get :pick
    assert_response :success
  end

  test "should get get_venue_info" do
    get :get_venue_info
    assert_response :success
  end

end
