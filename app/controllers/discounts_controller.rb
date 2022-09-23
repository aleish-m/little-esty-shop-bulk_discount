class DiscountsController < ApplicationController 
  def index
    @discounts = Discount.where(merchant_id: params[:merchant_id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @discount = merchant.discounts.new(discount_params)
    if @discount.save 
      flash.notice = "Discount was successfully added!"
      redirect_to(merchant_discounts_path(merchant))
    else
      flash.alert = @discount.errors.full_messages.to_sentence
      redirect_to(new_merchant_discount_path(merchant))
    end
  end

  private 
  def discount_params
    params.require(:discount).permit(:discount, :threshold)
  end
end