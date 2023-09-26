class Public::CustomersController < ApplicationController
    before_action :authenticate_customer!

    def show
        @customer = current_customer
    end

    def edit
        @customer = current_customer
    end

    def update
        @customer = current_customer
        if @customer.update(customer_params)
         redirect_to  customers_mypage_path, notice: "登録情報が更新されました。"
        else
        render :edit
        end
    end

    def withdraw
        @customer = Customer.find(current_customer.id)
        @customer.update(is_deleted: true)
        reset_session
        flash[:notice] = "退会処理を実行いたしました。"
        redirect_to root_path
    end

    def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :post_code, :address, :email,:phone_number)
    end

end
