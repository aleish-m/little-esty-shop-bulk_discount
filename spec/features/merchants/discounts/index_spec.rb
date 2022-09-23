 require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  describe 'As a merchant' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @discount_1 = create(:discount, merchant:@merchant_1)
    @discount_2 = create(:discount, merchant:@merchant_1)
    @discount_3 = create(:discount, merchant:@merchant_2)
  end
    describe 'When I visit my merchant dashboard' do
      it 'I see a link to view all my discounts. W~hen I click this link, I am taken to my bulk discounts index page' do
        visit merchant_dashboard_path(@merchant_1)

        click_link "Veiw Your Avalible Discounts"
        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end
    end

    describe 'I am taken to my bulk discounts index page' do
      it 'I see all of my bulk discounts including their percentage discount and quantity thresholds' do
        visit merchant_discounts_path(@merchant_1)
        within("#merchant-#{@merchant_1.id}-discounts") do
          within("#discount-#{@discount_1.id}") do
            expect(page).to have_content("Discount Percentage: #{@discount_1.discount.round(2)}")
            expect(page).to have_content("Discount Minumum Quantity: #{@discount_1.threshold}")
          end
          within("#discount-#{@discount_2.id}") do
            expect(page).to have_content("Discount Percentage: #{@discount_2.discount.round(2)}")
            expect(page).to have_content("Discount Minumum Quantity: #{@discount_2.threshold}")
          end
        end
        expect(page).to_not have_content("Discount Percentage: #{@discount_3.discount.round(2)}")
      end
      it 'Each bulk discount listed includes a link to its show page'
    end
  end
end