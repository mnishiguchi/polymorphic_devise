require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def test_home
    get static_pages_home_url
    assert_response :success
  end

end
