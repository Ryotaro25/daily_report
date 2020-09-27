require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "lyaout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "li#home", count: 1
    assert_select "li#accout"
  end
end
