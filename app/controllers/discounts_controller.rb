class DiscountsController < ApplicationController 
  def index
    @discounts = Discount.where(merchant_id: params[:merchant_id])
    # require "pry"; binding.pry
  end
end