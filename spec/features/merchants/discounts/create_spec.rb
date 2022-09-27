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

        fill_in "Discount Percentage (as decimal):", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Create Discount"

        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end

      it 'I see my new bulk discount listed' do
        visit new_merchant_discount_path(@merchant_1)

        fill_in "Discount Percentage (as decimal):", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Create Discount"

        visit merchant_discounts_path(@merchant_1)

        within("#merchant-#{@merchant_1.id}-discounts") do
          expect(page).to have_content("Discount: 25%")
          expect(page).to have_content("Minumum Order Quantity: 10")
        end
      end

      it "When I am redirected to the bulk discount's show page I see a message telling me the discount was updated" do
        visit new_merchant_discount_path(@merchant_1) 

        fill_in "Discount Percentage (as decimal):", with: "0.25"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Create Discount"

        expect(page).to have_content("Discount was successfully added!")
      
      end

      it "When I input an incorrect discount percentage I am redirected back to the the bulk discount new page I see a message telling me I entered an incorrect value" do
        visit new_merchant_discount_path(@merchant_1) 

        fill_in "Discount Percentage (as decimal):", with: "2"
        fill_in "Minimum Order Quantity:", with: "10"
        click_button "Create Discount"

        expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
        expect(page).to have_content("Discount must be less than or equal to 1")
      end

      it "When I input a non-numarical value in either discount form field I am redirected back to the the bulk discount new page I see a message telling me I feilds must be numbers" do
        visit new_merchant_discount_path(@merchant_1) 

        fill_in "Discount Percentage (as decimal):", with: "A"
        fill_in "Minimum Order Quantity:", with: "A"
        click_button "Create Discount"

        expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
        expect(page).to have_content("Threshold is not a number")
        expect(page).to have_content("Discount is not a number")
      end

      it "When don't fill in the discount fields I am redirected back to the the bulk discount new page I see a message telling me I feilds cannot be blank" do
        visit new_merchant_discount_path(@merchant_1)

        fill_in "Discount Percentage (as decimal):", with: ""
        fill_in "Minimum Order Quantity:", with: ""
        click_button "Update Discount"

        expect(current_path).to eq(new_merchant_discount_path(@merchant_1))
        expect(page).to have_content("Discount can't be blank, Discount is not a number, Threshold can't be blank, and Threshold is not a number")
      end
    end
  end
end