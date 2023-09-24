class Public::CartItemsController < ApplicationController
  
  def create
    @cart_item.user_id = current_user.id
  end
end
