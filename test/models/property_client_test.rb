# == Schema Information
#
# Table name: property_clients
#
#  id                   :integer          not null, primary key
#  name                 :string
#  account_executive_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require "test_helper"

class PropertyClientTest < ActiveSupport::TestCase
  def property_client
    @property_client ||= PropertyClient.new
  end

  def test_valid
    assert property_client.valid?
  end
end
