require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit' do
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
      it 'I see a link to edit the bulk discount , when I click this link I am taken to a new page with a form to edit the discount' do
        visit merchant_discount_path(@merchant_1, @discount_1)
        
        within("#discount-#{@discount_1.id}-details")do
          click_button("Edit Discount Info")
          save_and_open_page
          expect(current_path).to eq(edit_merchant_discount_path(@merchant_1, @discount_1))
        end
      end

      it "I see that the discounts current attributes are pre-poluated in the form, when I change any/all of the information and click submit I am redirected to the bulk discount's show page" do
        visit edit_merchant_discount_path(@merchant_1, @discount_1) 

        expect(page).to have_field("Discount Percentage:", with: "#{@discount_1.discount.round(3)}")
        expect(page).to have_field("Minimum Order Quantity:", with: "#{@discount_1.threshold}")

        fill_in "Discount Percentage:", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Update Discount"

        expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_1))
      end

      it "When I am redirected to the bulk discount's show page, and I see that the discount's attributes have been updated" do
        visit edit_merchant_discount_path(@merchant_1, @discount_1) 

        fill_in "Discount Percentage:", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Update Discount"

        within("#discount-#{@discount_1.id}-details")do
          expect(page).to have_content("25%")
          expect(page).to have_content(10)
        end
      end
    end
  end
end