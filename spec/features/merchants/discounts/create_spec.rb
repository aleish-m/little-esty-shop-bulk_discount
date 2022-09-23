require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Create' do
  describe 'As a merchant' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @discount_1 = create(:discount, merchant:@merchant_1)
    @discount_2 = create(:discount, merchant:@merchant_1)
    @discount_3 = create(:discount, merchant:@merchant_2)
  end
    describe 'When I visit my bulk discounts index' do
      it 'I see a link to create a new discount, when I click this link I am taken to a new page' do
        visit merchant_discounts_path(@merchant_1)

        click_button "Add New Bulk Discount"
        expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
      end
    end

    describe 'I am taken to a new page to add a new bulk discount' do
      it 'I fill in the form with valid data I am redirected back to the bulk discount index' do
        visit new_merchant_discount_path(@merchant_1)

        fill_in "Discount Percentage:", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Create Discount"

        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end

      it 'I see my new bulk discount listed' do
        visit merchant_discounts_path(@merchant_1)
      end
    end
  end
end