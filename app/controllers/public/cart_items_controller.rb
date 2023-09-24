class Public::CartItemsController < ApplicationController

  def create
    @cart_item = Cart_item.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
  end


  private
  def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount)
  end
end
