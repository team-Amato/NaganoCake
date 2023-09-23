class Admin::ItemsController < ApplicationController
   # before_action :authenticate_admin!
  #before_action :set_product, only: %i[show edit update]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash.now[:notice] = "商品の追加が成功しました"
      redirect_to admin_item_path(@item)
    else
      flash.now[:alert] = "商品の追加が失敗しました"
      render :new
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_items_path(@item)
    else
      redirect_to edit_admin_item_path(@item)
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :price, :explanation, :genre_id, :is_active, :item_image)
  end
  
end
