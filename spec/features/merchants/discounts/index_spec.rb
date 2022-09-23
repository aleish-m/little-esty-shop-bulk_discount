 require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  describe 'As a merchant' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
  end
    describe 'When I visit my merchant dashboard' do
      it 'I see a link to view all my discounts. W~hen I click this link, I am taken to my bulk discounts index page' do
        visit merchant_dashboard_path(@merchant_1)

        click_link "Veiw Your Avalible Discounts"
        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end
    end

    describe 'I am taken to my bulk discounts index page' do
      it 'I see all of my bulk discounts including their percentage discount and quantity thresholds'
      it 'Each bulk discount listed includes a link to its show page'
    end
  end
end