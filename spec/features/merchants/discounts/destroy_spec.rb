require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Delete' do
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

      it 'Next to each bulk discount, I see a link to delete it' do
        visit merchant_discounts_path(@merchant_1)
        
        within("#merchant-#{@merchant_1.id}-discounts") do
          within("#discount-#{@discount_1.id}") do
            expect(page).to have_button "Delete Discount"
          end
          within("#discount-#{@discount_2.id}") do
            expect(page).to have_button "Delete Discount"
          end
        end
      end

      it 'When I click this link, I am redirected back to the bulk discounts index page' do
        visit merchant_discounts_path(@merchant_1)

        within("#merchant-#{@merchant_1.id}-discounts") do
          within("#discount-#{@discount_1.id}") do
            click_button "Delete Discount"
          end
        end

        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end

      it 'I no longer see the discount listed' do 
        visit merchant_discounts_path(@merchant_1)

        within("#merchant-#{@merchant_1.id}-discounts") do
          within("#discount-#{@discount_1.id}") do
            expect(page).to have_content("Discount: #{(@discount_1.discount*100).round(0)}%")

            click_button "Delete Discount"
          end
        end

        within("#merchant-#{@merchant_1.id}-discounts") do
          
          expect(page).to_not have_content("Discount: #{(@discount_1.discount*100).round(0)}%")
          
          within("#discount-#{@discount_2.id}") do
            expect(page).to have_button "Delete Discount"
          end
        end
      end
    end
  end
end
