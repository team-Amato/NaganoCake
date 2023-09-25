class Public::ItemsController < ApplicationController

  def index
    @items = Item.all
    @item_counts = @items.count
    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
  end
end
