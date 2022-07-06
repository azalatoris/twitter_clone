require 'rails_helper'

RSpec.describe User, type: :model do
  it { should allow_value("Algirdas Zalatoris").for (:name) }
  it { should_not allow_value(nil).for (:name) }
  it { should_not allow_value("Alg.rdas Zala45toris").for (:name)}
  it { should validate_length_of(:name).is_at_most(32) }
  it { should validate_length_of(:name).is_at_least(6) }

  it { should allow_value("jonka").for (:handle) }
  it { should_not allow_value(nil).for (:handle) }
  it { should_not allow_value(" to: kac").for (:handle) }
  it { should allow_value("jon.35ka_").for (:handle) }
  it { should validate_length_of(:handle).is_at_least(4) }
  it { should validate_length_of(:handle).is_at_most(18) }

  it { should validate_length_of(:bio).is_at_least(4) }
  it { should validate_length_of(:bio).is_at_most(255) }

  it { should allow_value("a@a.com").for (:email) }
  it { should_not allow_value("algirdas.zalatoris").for (:email) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:handle) }
  it { should validate_uniqueness_of(:email) }

  it { is_expected.to have_many(:tweets) }
  it { is_expected.to have_many(:likes) }

end

