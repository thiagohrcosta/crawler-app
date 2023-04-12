class Vehicle < ApplicationRecord
  belongs_to :lead
  has_many :accessories

  validates :brand, presence: true, length: { maximum: 255 }
  validates :model, presence: true, length: { maximum: 255 }
  validates :km, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
