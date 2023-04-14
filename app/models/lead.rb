class Lead < ApplicationRecord
  has_many :vehicles

  validates :name, presence: true, length: { maximum: 255 }
  validates :phone, presence: true, length: { maximum: 20 }

  validates :message, presence: true
  validates :selected_vehicle, presence: true, length: { maximum: 255 }
  validates :price, presence: true
  validates :year, presence: true, length: { maximum: 4 }

  validates :link, presence: true
end
