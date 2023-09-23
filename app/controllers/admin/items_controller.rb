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
    if @item.update(item_params)
      flash.now[:notice] = "商品情報の編集が成功しました"
      redirect_to admin_item_path(@item)
    else
      flash.now[:alert] = "商品情報の編集が失敗しました"
      render :edit
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
