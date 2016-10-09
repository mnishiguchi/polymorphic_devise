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

FactoryGirl.define do
  factory :management_client do
    
  end
end
