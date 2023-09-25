class Public::CartItemsController < ApplicationController

  before_action :setup_item!, only: [:create]

  def index
    @cart_items = current_customer.cart_items
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    if @cart_item.save
      redirect_to cart_items_path
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path
  end

  def destroy_all
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    redirect_to cart_items_path
  end


  private

  def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount)
  end

  def setup_item
    byebug
    @cart_item = CartItem.find_by(item_id: params[:item_id])
  end
end