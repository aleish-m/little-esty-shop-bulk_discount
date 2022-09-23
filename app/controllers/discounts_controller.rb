class DiscountsController < ApplicationController 
  def index
    @discounts = Discount.where(merchant_id: params[:merchant_id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end
end