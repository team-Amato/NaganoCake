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

		@order = current_customer.orders.new(order_params)
    if @order.save
			cart_items.each do |cart|
			order_item = OrderItem.new
      order_item.item_id = cart.item_id
      order_item.order_id = @order.id
      order_item.order_amount = cart.amount

      order_item.order_price = cart.item.price
      order_item.save
      end
    redirect_to orders_thanks_path
    cart_items.destroy_all
    else
    @order = Order.new(order_params)
    render :new
    end
  end

  def index
    @orders = Order.where(member_id: current_member.id).order(created_at: :desc)#注文履歴を降順で並べる
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
      @cart_items = current_customer.cart_items.all

      ary = []
		  @cart_items.each do |cart_item|
			 ary << (cart_item.item.with_tax_price).floor * cart_item.amount
		end
		  @cart_items_price = ary.sum
		  @postage = 800
		  @total_price = @postage + @cart_items_price

      session[:order][:payment_method] = params[:method].to_i

		# 以下、order_detail作成
		cart_items = current_customer.cart_items
		cart_items.each do |cart_item|
			order_detail = OrderDetail.new
			order_detail.order_id = @order.id
			order_detail.item_id = cart_item.item.id
			order_detail.amount = cart_item.amount
			order_detail.making_status = 0
			order_detail.purchase_price = (cart_item.item.price * 1.1).floor
			order_detail.save
		end

		# 購入後はカート内商品削除
		cart_items.destroy_all
  end

  def show
    @order = Order.find(params[:id])
    @order_details= OrderDetail.where(order_id: @order.id)
  end

  def thanks
  end

  private

  def orders_params
    params.require(:order).permit(:customer_id, :post_code, :name, :address, :payment_method, :status, :postage, :total_price)
  end

end
