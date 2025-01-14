require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)

    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)

    @invoice_items_1 = create(:invoice_items, invoice_id: @invoice_1.id, item_id: @item_1.id, status: "pending")
    @invoice_items_2 = create(:invoice_items, invoice_id: @invoice_2.id, item_id: @item_2.id, status: "pending")

  end

  describe 'User Story 15 - When I visit my merchants invoice show page' do
    it 'Then I see information related to that invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#invoice-info") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@invoice_1.customer.first_name)
        expect(page).to have_content(@invoice_1.customer.last_name )
        expect(page).to_not have_content(@invoice_2.id)
        expect(page).to_not have_content(@invoice_2.customer.first_name)
        expect(page).to_not have_content(@invoice_2.customer.last_name)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_2)

      within("#invoice-info") do
        expect(page).to have_content(@invoice_2.id)
        expect(page).to have_content(@invoice_2.status)
        expect(page).to have_content(@invoice_2.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@invoice_2.customer.first_name)
        expect(page).to have_content(@invoice_2.customer.last_name )
        expect(page).to_not have_content(@invoice_1.id)
        expect(page).to_not have_content(@invoice_1.customer.first_name)
        expect(page).to_not have_content(@invoice_1.customer.last_name)
      end
    end
  end

  describe 'User Story 16 - When I visit my merchant invoice show page' do
    it 'Then I see all of my items on the invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#invoice-items-info") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content((@item_1.unit_price/100.00).to_s(:delimited))
        expect(page).to have_content(@invoice_items_1.status)
        expect(page).to have_content(@invoice_items_1.quantity)
        expect(page).to_not have_content(@item_2.name)
        expect(page).to_not have_content((@item_2.unit_price/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_2, @invoice_2)

      within("#invoice-items-info") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content((@item_2.unit_price/100.00).to_s(:delimited))
        expect(page).to have_content(@invoice_items_2.status)
        expect(page).to have_content(@invoice_items_2.quantity)
        expect(page).to_not have_content(@item_1.name)
        expect(page).to_not have_content((@item_1.unit_price/100.00).to_s(:delimited))
      end
    end
  end

  describe 'User Story 18 When I visit my merchant invoice show page' do
    it 'I see that each invoice item status is a select field' do
      visit  merchant_invoice_path(@merchant_1, @invoice_1)

      within "#invoice-items-info" do
        expect(page).to have_select("invoice[status]", selected: "#{@invoice_items_1.status.titleize}")
      end

      visit  merchant_invoice_path(@merchant_2, @invoice_2)

      within "#invoice-items-info" do
        expect(page).to have_select("invoice[status]", selected: "#{@invoice_items_2.status.titleize}")
      end
    end

    it 'When I click this select field, select a new status, click button I am taken back to merchant invoice show page' do
      visit  merchant_invoice_path(@merchant_1, @invoice_1)

      select "Shipped", from: "invoice[status]"

      click_button "Update Item Status"

      expect(current_path).to eq( merchant_invoice_path(@merchant_1, @invoice_1))
      within "#invoice-items-info" do
        expect(page).to have_content("Shipped")
      end

      visit  merchant_invoice_path(@merchant_2, @invoice_2)

      select "Packaged", from: "invoice[status]"

      click_button "Update Item Status"

      expect(current_path).to eq( merchant_invoice_path(@merchant_2, @invoice_2))
      within "#invoice-items-info" do
        expect(page).to have_content("Packaged")
      end
    end
  end

  describe 'User Story 17 - When I visit my merchant invoice show page' do
    before :each do
      @merchant_1 = create(:merchant)
      
      @item_1 = create(:item, name: "item_1", merchant: @merchant_1, active_status: :enabled)
      @item_2 = create(:item, name: "item_2", merchant: @merchant_1)
      @item_3 = create(:item, name: "item_3", merchant: @merchant_1)
      @item_4 = create(:item, name: "item_4", merchant: @merchant_1, active_status: :enabled)
      @item_5 = create(:item, name: "item_5", merchant: @merchant_1, active_status: :enabled)
      @item_6 = create(:item, name: "item_6", merchant: @merchant_1)
      @item_7 = create(:item, name: "item_7", merchant: @merchant_1, active_status: :enabled)
      @item_8 = create(:item, name: "item_8", merchant: @merchant_1)
      @item_9 = create(:item, name: "item_9", merchant: @merchant_1, active_status: :enabled)
      @item_10 = create(:item, name: "item_10", merchant: @merchant_1)

      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)
      @invoice_3 = create(:invoice)
      @invoice_4 = create(:invoice)

      create(:invoice_items, invoice: @invoice_1, item: @item_10, unit_price: 1000, quantity: 10)
      create(:invoice_items, invoice: @invoice_1, item: @item_5, unit_price: 900, quantity: 9)
      create(:invoice_items, invoice: @invoice_1, item: @item_3, unit_price: 800, quantity: 8)

      create(:invoice_items, invoice: @invoice_2, item: @item_7, unit_price: 700, quantity: 7)
      create(:invoice_items, invoice: @invoice_2, item: @item_6, unit_price: 600, quantity: 6)

      create(:invoice_items, invoice: @invoice_3, item: @item_2, unit_price: 500, quantity: 5)
      create(:invoice_items, invoice: @invoice_3, item: @item_4, unit_price: 400, quantity: 4)
      create(:invoice_items, invoice: @invoice_4, item: @item_8, unit_price: 300, quantity: 3)
      create(:invoice_items, invoice: @invoice_4, item: @item_9, unit_price: 200, quantity: 2)
      create(:invoice_items, invoice: @invoice_4, item: @item_1, unit_price: 100, quantity: 1)

      create_list(:transaction, 5, invoice: @invoice_1, result: :success)
      create_list(:transaction, 5, invoice: @invoice_1, result: :failed)
      create_list(:transaction, 5, invoice: @invoice_2, result: :failed)
      create_list(:transaction, 5, invoice: @invoice_2, result: :success)
      create_list(:transaction, 5, invoice: @invoice_3, result: :failed)
      create_list(:transaction, 5, invoice: @invoice_3, result: :failed)
      create_list(:transaction, 5, invoice: @invoice_4, result: :success)
      create_list(:transaction, 5, invoice: @invoice_4, result: :success)
    end

    it 'Then I see the total revenue that will be generated from all of my items on the invoice' do
      
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      
      within "#invoice-revenue" do
        expect(page).to have_content((@invoice_1.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)

      within "#invoice-revenue" do
        expect(page).to have_content((@invoice_2.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_1, @invoice_3)

      within "#invoice-revenue" do
        expect(page).to have_content((@invoice_3.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_1, @invoice_4)

      within "#invoice-revenue" do
        expect(page).to have_content((@invoice_4.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end
    end
  end

  describe 'total revenue for my merchant from this invoice' do
    before :each do
      @merchant_1 = create(:merchant)
      
      @item_1 = create(:item, name: "item_1", merchant: @merchant_1, active_status: :enabled)
      @item_2 = create(:item, name: "item_2", merchant: @merchant_1)
      @item_3 = create(:item, name: "item_3", merchant: @merchant_1)
      @item_4 = create(:item, name: "item_4", merchant: @merchant_1, active_status: :enabled)
      @item_5 = create(:item, name: "item_5", merchant: @merchant_1, active_status: :enabled)
      
      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)

      create(:invoice_items, invoice: @invoice_1, item: @item_5, unit_price: 1000, quantity: 10) #5000, 10000
      create(:invoice_items, invoice: @invoice_1, item: @item_4, unit_price: 900, quantity: 9) #4050, 8100
      create(:invoice_items, invoice: @invoice_1, item: @item_3, unit_price: 800, quantity: 8) #3200, 6400

      create(:invoice_items, invoice: @invoice_2, item: @item_2, unit_price: 700, quantity: 7) #3675, 4900
      create(:invoice_items, invoice: @invoice_2, item: @item_1, unit_price: 600, quantity: 6) #3600, 3600

      create_list(:transaction, 1, invoice: @invoice_1, result: :success)
      create_list(:transaction, 1, invoice: @invoice_1, result: :failed)
      create_list(:transaction, 1, invoice: @invoice_2, result: :failed)
      create_list(:transaction, 1, invoice: @invoice_2, result: :success)

      @discount_1 = create(:discount, discount: 0.25, threshold: 7, merchant: @merchant_1)
      @discount_2 = create(:discount, discount: 0.5, threshold: 8, merchant: @merchant_1)
      @discount_3 = create(:discount, discount: 0.20, threshold: 10, merchant: @merchant_1)
    end

    it 'I see the total revenue for my merchant from this invoice (not including discounts)' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      within("#invoice-revenue") do
        expect(page).to have_content((@invoice_1.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("#invoice-revenue") do
        expect(page).to have_content((@invoice_2.items.total_revenue_of_all_items/100.00).to_s(:delimited))
      end
    end

    it 'I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      
      within("#invoice-revenue") do
        expect(page).to have_content((@invoice_1.discounted_revenue_of_invoice/100.00).to_s(:delimited))
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("#invoice-revenue") do
        expect(page).to have_content((@invoice_2.discounted_revenue_of_invoice/100.00).to_s(:delimited))
      end
    end

    it 'Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("#invoice-items-info") do
        within("#item-#{@item_5.id}-discount") do
          click_link'View Discount Info'
        end
      end

      expect(current_path).to eq(merchant_discount_path(@merchant_1, @discount_2))
    end
  end
end