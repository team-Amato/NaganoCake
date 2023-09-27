class Item < ApplicationRecord

  validates :name, presence: true
  validates :price, presence: true
  validates :explanation, presence: true
  validates :is_active, inclusion: { in: [true, false] }
  validates :item_image, presence: true

  has_one_attached :item_image
  belongs_to :genre
  # belongs_to :order
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy

  def get_item_image(width, height)
    unless item_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      item_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
      item_image.variant(resize_to_limit: [width, height]).processed
  end

  ## 消費税を求めるメソッド
  def with_tax_price
      (price * 1.1).floor
  end

  def total_item_amount #アイテム合計金額
   order_details.sum { |order_detail| order_detail.subtotal }
  end

end
