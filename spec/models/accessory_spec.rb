require 'rails_helper'

RSpec.describe Accessory, type: :model do
  describe 'associations' do
    it { should belong_to(:vehicle) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
  end
end
