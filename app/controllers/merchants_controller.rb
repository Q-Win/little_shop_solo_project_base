class MerchantsController < ApplicationController
  def index
    if current_admin?
      @merchants = User.where(role: :merchant).order(:name)
    else
      @merchants = User.where(role: :merchant, active: true).order(:name)
    end
    @top_merch_for_month = User.top_item_selling_merch_for_month(Time.now.month, 10)
    @merch_who_fullfill = User.merchants_who_fulfilled_non_cancelled_orders_this_month(Time.now.month, 10)
    if current_user
    # binding.pry
      @fast_in_my_state = User.fastest_in_my_state(current_user.state,5)
      @fast_in_my_city = User.fastest_in_my_city(current_user.city,5)
    end
  end

  def show
    render file: 'errors/not_found', status: 404 unless current_user

    @merchant = User.find(params[:id])
    if current_admin?
      @orders = current_user.merchant_orders
      if @merchant.user?
        redirect_to user_path(@merchant)
      end
    elsif current_user != @merchant
      render file: 'errors/not_found', status: 404
    end
  end
end
