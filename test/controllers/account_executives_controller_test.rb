require "test_helper"

class AccountExecutivesControllerTest < ActionDispatch::IntegrationTest
  def account_executive
    @account_executive ||= account_executives :one
  end

  def test_index
    get account_executives_url
    assert_response :success
  end

  def test_new
    get new_account_executive_url
    assert_response :success
  end

  def test_create
    assert_difference "AccountExecutive.count" do
      post account_executives_url, params: { account_executive: {  } }
    end

    assert_redirected_to account_executive_path(AccountExecutive.last)
  end

  def test_show
    get account_executive_url(account_executive)
    assert_response :success
  end

  def test_edit
    get edit_account_executive_url(account_executive)
    assert_response :success
  end

  def test_update
    patch account_executive_url(account_executive), params: { account_executive: {  } }
    assert_redirected_to account_executive_path(account_executive)
  end

  def test_destroy
    assert_difference "AccountExecutive.count", -1  do
      delete account_executive_url(account_executive)
    end

    assert_redirected_to account_executives_path
  end
end
