class Order < ApplicationRecord
  belongs_to :customer
  has_one_attached :item_image
  has_many :order_details, dependent: :destroy
  #has_many :items, dependent: :destroy
  enum status: { payment_waiting: 0, payment_confirmation: 1, in_production: 2, preparing_delivery: 3, delivered: 4 }
  enum payment_method: { credit_card: 0, transfer: 1 }

  def get_item_image(width, height)
    unless item_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      item_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
      item_image.variant(resize_to_limit: [width, height]).processed
  end

  def with_tax_price
      (price * 1.1).floor
  end
end
