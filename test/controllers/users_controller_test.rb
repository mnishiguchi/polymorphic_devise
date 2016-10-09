require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= users :one
  end

  def test_index
    get users_url
    assert_response :success
  end

  def test_new
    get new_user_url
    assert_response :success
  end

  def test_create
    assert_difference "User.count" do
      post users_url, params: { user: {  } }
    end

    assert_redirected_to user_path(User.last)
  end

  def test_show
    get user_url(user)
    assert_response :success
  end

  def test_edit
    get edit_user_url(user)
    assert_response :success
  end

  def test_update
    patch user_url(user), params: { user: {  } }
    assert_redirected_to user_path(user)
  end

  def test_destroy
    assert_difference "User.count", -1  do
      delete user_url(user)
    end

    assert_redirected_to users_path
  end
end
