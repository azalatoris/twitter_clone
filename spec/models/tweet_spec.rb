require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it { should validate_length_of(:content).is_at_least(3) }
  it { should validate_length_of(:content).is_at_most(280) }
end
