require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show' do
  describe 'As a merchant' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @discount_1 = create(:discount, merchant:@merchant_1)
    @discount_2 = create(:discount, merchant:@merchant_1)
    @discount_3 = create(:discount, merchant:@merchant_2)
  end
    describe 'When I visit my bulk discount show page' do
      it "Then I see the bulk discount's quantity threshold and the percentage discount" do
        visit merchant_discount_path(@merchant_1, @discount_1)

        within("#discount-#{@discount_1.id}-details") do
          expect(page).to have_content("Discount: #{(@discount_1.discount*100).round(0)}%")
          expect(page).to have_content("Minumum Order Quantity: #{@discount_1.threshold}")
        end
         
        expect(page).to_not have_content("Discount: #{(@discount_2.discount*100).round(0)}%")
        expect(page).to_not have_content("Minumum Order Quantity: #{@discount_2.threshold}")
      end
    end
  end
end