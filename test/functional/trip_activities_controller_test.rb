require 'test_helper'

class TripActivitiesControllerTest < ActionController::TestCase
  setup do
    @trip_activity = trip_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trip_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trip_activity" do
    assert_difference('TripActivity.count') do
      post :create, trip_activity: {  }
    end

    assert_redirected_to trip_activity_path(assigns(:trip_activity))
  end

  test "should show trip_activity" do
    get :show, id: @trip_activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trip_activity
    assert_response :success
  end

  test "should update trip_activity" do
    put :update, id: @trip_activity, trip_activity: {  }
    assert_redirected_to trip_activity_path(assigns(:trip_activity))
  end

  test "should destroy trip_activity" do
    assert_difference('TripActivity.count', -1) do
      delete :destroy, id: @trip_activity
    end

    assert_redirected_to trip_activities_path
  end
end
