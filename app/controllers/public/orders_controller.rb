class Public::OrdersController < ApplicationController
  def new
  	@order = Order.new
  	@customer = current_customer
    @addresses = Address.where(customer_id: current_customer.id)
  end

# 注文の確定をするアクション
  def create
    @customer = current_customer
		@cart_items = current_customer.cart_items.all

		@order = current_customer.order.new(orders_params)
    if @order.save
			@cart_items.each do |cart|
			order_item = OrderDetail.new
      order_item.item_id = cart.item_id
      order_item.order_id = @order.id
      order_item.amount = cart.amount
      order_item.purchase_price = cart.item.price
      order_item.making_status = 0
      order_item.save
      end
    redirect_to orders_thanks_path
    @cart_items.destroy_all
    else
    @order = Order.new(order_params)
    render :new
    end
  end

  def index
    @orders = Order.all.order(created_at: :desc)#注文履歴を降順で並べる
  end

  def confirm
    @order = Order.new(orders_params)
    @cart_items = current_customer.cart_items

    if params[:order][:address_number] == "1"
    	@order.name = current_customer.first_name + current_customer.last_name
    	@order.address = current_customer.address
    	@order.post_code = current_customer.post_code

    elsif params[:order][:address_number] == "2"
      if Address.exists?(name: params[:order][:registered])
      	# @address = Address.find(params[:order][:address_id])
      	@order.name = Address.find(params[:order][:registered]).name
        @order.address = Address.find(params[:order][:registered]).address
      else
      render :new
      end

    elsif params[:order][:address_number] == "3"
    	address_new = current_customer.addresses.new(address_params)
    if address_new.save
    else
      render :new
    end
    else
      redirect_to orders_confirm_path
    end

      ary = []
		  @cart_items.each do |cart_item|
			 ary << (cart_item.item.with_tax_price).floor * cart_item.amount
		end
		  @cart_items_price = ary.sum
		  @order.postage = 800
		  @order.status = 0
		  @total_price = @order.postage + @cart_items_price
		  @order.total_price = @total_price
  end

  def show
    @order_new = Order.new
    @order = Order.find(params[:id])
    @orders = Order.all
    @order_details= OrderDetail.where(order_id: @order.id)
    @order_details_all = @order.order_details.all
    @total_item_amount = @order_details.sum { |order_detail| order_detail.subtotal }
  end
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

  def thanks
  end

  private

  def orders_params
    params.require(:order).permit(:customer_id, :post_code, :name, :address, :payment_method, :status, :postage, :total_price, :status, :purchase_price)
  end

end
