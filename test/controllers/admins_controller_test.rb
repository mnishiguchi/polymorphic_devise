require "test_helper"

class AdminsControllerTest < ActionDispatch::IntegrationTest
  def admin
    @admin ||= admins :one
  end

  def test_index
    get admins_url
    assert_response :success
  end

  def test_new
    get new_admin_url
    assert_response :success
  end

  def test_create
    assert_difference "Admin.count" do
      post admins_url, params: { admin: {  } }
    end

    assert_redirected_to admin_path(Admin.last)
  end

  def test_show
    get admin_url(admin)
    assert_response :success
  end

  def test_edit
    get edit_admin_url(admin)
    assert_response :success
  end

  def test_update
    patch admin_url(admin), params: { admin: {  } }
    assert_redirected_to admin_path(admin)
  end

  def test_destroy
    assert_difference "Admin.count", -1  do
      delete admin_url(admin)
    end

    assert_redirected_to admins_path
  end
end
