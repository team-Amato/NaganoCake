class Public::AddressesController < ApplicationController
  def index
    @addresses = Address.all
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
    unless @address.customer_id == current_customer.id
      redirect_to addresses_path
    end
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      flash[:notice] = "You have created address successfully."
      redirect_to addresses_path
    else
      @addresses = current_customer.addresses
      render :index
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:notice] = "You have updated address successfully."
      redirect_to addresses_path
    else
      flash[:notice] = "You failed to update address."
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:customer_id, :address, :post_code, :name)
  end
end

