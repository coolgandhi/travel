require 'test_helper'

class AuthorInfoControllerTest < ActionController::TestCase
  test "should get about_edit" do
    get :about_edit
    assert_response :success
  end

  test "should get about_update" do
    get :about_update
    assert_response :success
  end

  test "should get author_page" do
    get :author_page
    assert_response :success
  end

end
