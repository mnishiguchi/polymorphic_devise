require "test_helper"

class PropertyClientsControllerTest < ActionDispatch::IntegrationTest
  def property_client
    @property_client ||= property_clients :one
  end

  def test_index
    get property_clients_url
    assert_response :success
  end

  def test_new
    get new_property_client_url
    assert_response :success
  end

  def test_create
    assert_difference "PropertyClient.count" do
      post property_clients_url, params: { property_client: {  } }
    end

    assert_redirected_to property_client_path(PropertyClient.last)
  end

  def test_show
    get property_client_url(property_client)
    assert_response :success
  end

  def test_edit
    get edit_property_client_url(property_client)
    assert_response :success
  end

  def test_update
    patch property_client_url(property_client), params: { property_client: {  } }
    assert_redirected_to property_client_path(property_client)
  end

  def test_destroy
    assert_difference "PropertyClient.count", -1  do
      delete property_client_url(property_client)
    end

    assert_redirected_to property_clients_path
  end
end
