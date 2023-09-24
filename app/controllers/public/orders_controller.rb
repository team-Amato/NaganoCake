class Public::OrdersController < ApplicationController
  def new
  end
  
  def create
    @order = Order.new
    @order.member_id = current_member.id
    @order.postage = 800
    @cart_items = CartItem.where(member_id: current_member.id)
    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.price*cart_item.quantity
    end
    @cart_items_price = ary.sum
    @order.total_price = @order.postage + @cart_items_price
    @order.pay_method = params[:order][:pay_method]
    if @order.pay_method == "credit_card"
      @order.status = 1
    else
      @order.status = 0
    end
    # 配送先の選択
    address_type = params[:order][:address_type]
      case address_type
    when "member_address"
      @order.post_code = current_member.post_code
      @order.address = current_member.address
      @order.name = current_member.last_name + current_member.first_name
    when "registered_address"
      Addresse.find(params[:order][:registered_address_id])
      selected = Addresse.find(params[:order][:registered_address_id])
      @order.post_code = selected.post_code
      @order.address = selected.address
      @order.name = selected.name
    when "new_address"
      @order.post_code = params[:order][:new_post_code]
      @order.address = params[:order][:new_address]
      @order.name = params[:order][:new_name]
    end
    
    if @order.save
      if @order.status == 0
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity, making_status: 0)
        end
      else
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity, making_status: 1)
        end
      end
      @cart_items.destroy_all
      redirect_to orders_thanks_path
    else
      render :items
    end
  end    
  end
    
  def index
     @orders = Order.where(member_id: current_member.id).order(created_at: :desc).#注文履歴を降順で並べる
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details= OrderDetail.where(order_id: @order.id)
  end
  
  def confirm
    @cart_items = CartItem.where(member_id: current_member.id)
    @postage = 800   #送料を800円で固定する
    @selected_pay_method = params[:order][:pey_method]
      
    # 商品合計額の計算
    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.price*cart_item.quantity
    end
    @cart_items_price = ary.sum
    @total_price = @postage + @cart_items_price
    
    # 配送先の確認
    @address_type = params[:order][:address_type]
    case @address_type
    when "member_address"
      @selected_address = current_member.post_code + " " + current_member.address + " " + current_member.last_name + current_member.first_name then
    when "registered_address"
    unless params[:order][:registered_address_id] == ""
      selected = Address.find(params[:order][:registered_address_id]
      @selected_address = selected.post_code + "" + selected.address + "" + selected.name then
	  else	 
	   render :new
	  end
    when "new_address"
    unless params[:order][:new_post_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
	    @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
	  else
	   render :new
	  end
  end     
  end
  
  def thanks
  end

end
