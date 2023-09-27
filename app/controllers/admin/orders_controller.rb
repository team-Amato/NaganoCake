class Admin::OrdersController < ApplicationController
  def index
      @orders = Order.all.order(created_at: :desc)
  end
  def show
    @order = Order.find(params[:id])
    @orders = Order.all
    @order_items = @order.order_details.all
    @total_subtotal = 0
    @postage = 800
  end
  def update
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: params[:id])
    if @order.update(order_params)
      @order_details.update_all(making_status: 1) if @order.status == "payment_confirmation"
      ## ①注文ステータスが「入金確認」とき、製作ステータスを全て「製作待ち」に更新する
    end
    redirect_to admin_order_path(@order)
  end
  private
  def order_params
    params.require(:order).permit(:status)
  end
end














