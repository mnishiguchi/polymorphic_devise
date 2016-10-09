# == Schema Information
#
# Table name: account_executives
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class AccountExecutiveTest < ActiveSupport::TestCase
  def account_executive
    @account_executive ||= AccountExecutive.new
  end

  def test_valid
    assert account_executive.valid?
  end
end
