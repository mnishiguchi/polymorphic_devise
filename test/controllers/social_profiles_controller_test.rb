require "test_helper"

class SocialProfilesControllerTest < ActionDispatch::IntegrationTest
  def test_destroy
    get social_profiles_destroy_url
    assert_response :success
  end

end
