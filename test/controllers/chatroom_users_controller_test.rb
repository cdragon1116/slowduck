require 'test_helper'

class ChatroomUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get chatroom_users_create_url
    assert_response :success
  end

  test "should get show" do
    get chatroom_users_show_url
    assert_response :success
  end

  test "should get destroy" do
    get chatroom_users_destroy_url
    assert_response :success
  end

end
