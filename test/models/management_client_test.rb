# == Schema Information
#
# Table name: management_clients
#
#  id                   :integer          not null, primary key
#  name                 :string
#  account_executive_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require "test_helper"

class ManagementClientTest < ActiveSupport::TestCase
  def management_client
    @management_client ||= ManagementClient.new
  end

  def test_valid
    assert management_client.valid?
  end
end
