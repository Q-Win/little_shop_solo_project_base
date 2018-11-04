class DiscountsController < ApplicationController

  def new
    @item = Item.find(params[:item_id])
    @discount = Discount.new
  end

  def create
    item = Item.find(params[:item_id])
    discount = item.discounts.new(discount_params)
    if discount.save
      redirect_to items_path
    else
      flash[:notice] = "Please double check the discount info and try again"
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def discount_params
      params.require(:discount).permit(:item_id, :rate, :quantity)
    end
end
