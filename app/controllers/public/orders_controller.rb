class Public::OrdersController < ApplicationController
  def new
  	@order = Order.new
  	@customer = current_customer
    @addresses = Address.where(customer_id: current_customer.id)
  end

  def create
    @customer = current_customer

		# sessionを使ってデータを一時保存
		session[:order] = Order.new

		@cart_items = current_customer.cart_items

		# total_paymentのための計算
		sum = 0
		@cart_items.each do |cart_item|
			sum += cart_item.item.price*cart_item.amount
		end

		session[:order][:postage] = 800
		session[:order][:total_price] = sum + session[:order][:postage]
		session[:order][:status] = 0
		session[:order][:customer_id] = current_customer.id
		# ラジオボタンで選択された支払方法のenum番号を渡している
		session[:order][:payment_method] = params[:method].to_i

		# ラジオボタンで選択されたお届け先によって条件分岐
		destination = params[:a_method].to_i

		# ご自身の住所が選択された時
		if destination == 0
			session[:order][:post_code] = @customer.post_code
			session[:order][:address] = @customer.address
			session[:order][:name] = @customer.last_name + @customer.first_name
		# 登録済住所が選択された時
		elsif destination == 1
			address = ShippingAddress.find(params[:shipping_address_for_order])
			session[:order][:post_code] = address.postal_code
			session[:order][:address] = address.address
			session[:order][:name] = address.name
		# 新しいお届け先が選択された時
		elsif destination == 2
			session[:new_address] = 2
			session[:order][:post_code] = params[:post_code]
			session[:order][:address] = params[:address]
			session[:order][:name] = params[:name]
		end

	  if @order.save
	      if @order.status == 0
	        @cart_items.each do |cart_item|
	          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: 0)
	        end
	      else
	        @cart_items.each do |cart_item|
	          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: 1)
	        end
	      end
	      redirect_to orders_confirm_path
	  else
	      render new_order_path
	  end
  end

  def index
    @orders = Order.where(member_id: current_member.id).order(created_at: :desc)#注文履歴を降順で並べる
  end

  def confirm
    @order = Order.new(session[:order])
    @cart_items = CartItem.all

		if session[:new_address]
			shipping_address = current_customer.shipping_addresses.new
			shipping_address.post_code = @order.post_code
			shipping_address.address = @order.address
			shipping_address.name = @order.name
			shipping_address.save
			session[:new_address] = nil
		end

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
    params.require(:orders).permit(:customer_id, :post_code, :name, :address, :payment_method, :status, :postage, :total_price)
  end

end
