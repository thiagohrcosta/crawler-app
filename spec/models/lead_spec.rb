require 'rails_helper'

RSpec.describe Lead, type: :model do

  describe 'associations' do
    it { should have_many(:vehicles) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:selected_vehicle) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:link) }

    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:phone).is_at_most(20) }
    it { should validate_length_of(:selected_vehicle).is_at_most(255) }
    it { should validate_length_of(:year).is_at_most(4) }
  end
end
