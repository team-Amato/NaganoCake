class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    amount * item.with_tax_price
  end
end
