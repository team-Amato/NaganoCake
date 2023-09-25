class Public::CartItemsController < ApplicationController


  def index
    @cart_items = current_customer.cart_items
  end

  def create
    # 同じ商品が既にある場合の処理
    # 同一商品のレコードをcart_itemからfind_byで検索
    @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]) 
    if @cart_item
      @amount = @cart_item.amount.to_i + params[:cart_item][:amount].to_i
      @cart_item.update(amount: @amount)
    else
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      @cart_item.save
    end
    redirect_to cart_items_path
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

end