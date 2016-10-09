# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class AdminTest < ActiveSupport::TestCase
  def admin
    @admin ||= Admin.new
  end

  def test_valid
    assert admin.valid?
  end
end
