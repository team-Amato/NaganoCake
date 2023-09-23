class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :explanation, presence: true
  validates :is_active, presence: true
  validates :item_image, presence: true

  has_one_attached :item_image
  belongs_to :genre
end
