require 'test_helper'

class GroupControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get group_new_url
    assert_response :success
  end

end
