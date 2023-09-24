class Public::ItemsController < ApplicationController

  def index
    @items = Item.all
    @item_counts = @items.count
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end

end
