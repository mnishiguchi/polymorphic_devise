require "test_helper"

class ManagementClientsControllerTest < ActionDispatch::IntegrationTest
  def management_client
    @management_client ||= management_clients :one
  end

  def test_index
    get management_clients_url
    assert_response :success
  end

  def test_new
    get new_management_client_url
    assert_response :success
  end

  def test_create
    assert_difference "ManagementClient.count" do
      post management_clients_url, params: { management_client: {  } }
    end

    assert_redirected_to management_client_path(ManagementClient.last)
  end

  def test_show
    get management_client_url(management_client)
    assert_response :success
  end

  def test_edit
    get edit_management_client_url(management_client)
    assert_response :success
  end

  def test_update
    patch management_client_url(management_client), params: { management_client: {  } }
    assert_redirected_to management_client_path(management_client)
  end

  def test_destroy
    assert_difference "ManagementClient.count", -1  do
      delete management_client_url(management_client)
    end

    assert_redirected_to management_clients_path
  end
end
