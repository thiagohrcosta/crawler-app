require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'associations' do
    it { should belong_to(:lead) }
    it { should have_many(:accessories)}
  end

  describe 'validations' do
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:km) }

    it { should validate_length_of(:brand).is_at_most(255) }
    it { should validate_length_of(:model).is_at_most(255) }

    it { should validate_numericality_of(:km).is_greater_than_or_equal_to(0) }
  end
end
