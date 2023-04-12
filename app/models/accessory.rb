class Accessory < ApplicationRecord
  belongs_to :vehicle

  validates :name, presence: true, length: { maximum: 255 }
end
