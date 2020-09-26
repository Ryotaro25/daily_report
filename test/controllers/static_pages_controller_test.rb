require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Daily Work Report"
  end

  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "home | #{@base_title}"
  end

  test "should get members" do
    get members_url
    assert_response :success
    assert_select "title", "members | #{@base_title}"
  end

  test "should get account" do
    get account_url
    assert_response :success
    assert_select "title", "account | #{@base_title}"
  end

end
