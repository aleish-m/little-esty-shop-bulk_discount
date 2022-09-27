require 'rails_helper'

RSpec.describe "Admin Invoice Show Page" do
  describe "As an admin" do
    describe "I visit an admin invoice show page" do
      before :each do
        @items_1 = create_list(:item, 10)
        @items_2 = create_list(:item, 10)
        @items_3 = create_list(:item, 10)
        @items_4 = create_list(:item, 10)
      
        @invoice_1 = create(:invoice)
        @invoice_2 = create(:invoice)
        @invoice_3 = create(:invoice)
        @invoice_4 = create(:invoice)

        @items_1.each { |item| create(:invoice_items, invoice_id: @invoice_1.id, item_id: item.id) }
        @items_2.each { |item| create(:invoice_items, invoice_id: @invoice_2.id, item_id: item.id) }

        @transaction_1 = create(:transaction, invoice: @invoice_1, result: :success)
        @transaction_2 = create(:transaction, invoice: @invoice_1, result: :failed)
        @transaction_3 = create(:transaction, invoice: @invoice_2, result: :success)
      end

      it 'I see information related to that invoice including: id, status, created_at date (format "Monday, July 18, 2019") and Customer First+Last name' do
        visit admin_invoice_path(@invoice_1)

        within("#invoice-details-#{@invoice_1.id}") do
          expect(page).to have_content("Invoice ##{@invoice_1.id}")
          expect(page).to have_content("#{@invoice_1.status.titleize}")
          expect(page).to have_content("Created On: #{@invoice_1.created_at.strftime("%A, %B %d, %Y")}")
          expect(page).to have_content("#{@invoice_1.customer.first_name} #{@invoice_1.customer.last_name}")
        end
        
        expect(page).to_not have_content("Invoice ##{@invoice_3.id}")
        expect(page).to_not have_content("#{@invoice_3.customer.first_name} #{@invoice_3.customer.last_name}")
      end

      it "I see all of the items on the invoice including: Item name, quantity ordered, price Item sold for, Item status" do
        visit admin_invoice_path(@invoice_1)

         within("#invoice-items") do
          @invoice_1.items.each do |item|
            expect(page).to have_content(item.name)
            expect(page).to have_content(item.quantity_purchased(@invoice_1.id))
            expect(page).to have_content((item.price_sold(@invoice_1.id)/100.00).to_s(:delimited))
            expect(page).to have_content(item.shipping_status(@invoice_1.id).capitalize)

            expect(page).to_not have_content(@invoice_2.items.any?{|item| item.name})
          end
        end
      end

      it "I see the invoice status is a select field And I see that the invoice's current status is selected" do
        visit admin_invoice_path(@invoice_1)
        expect(page).to have_select("Invoice Status:", selected: "#{@invoice_1.status.titleize}")

      end

      it "When I click this select field, Then I can select a new status for the Invoice And next to the select field I see a button to 'Update Invoice Status'" do
        visit admin_invoice_path(@invoice_1)
        select 'In Progress', from: 'Invoice Status'
        expect(page).to have_button("Update Invoice")
      end

      it "When I click 'Update Invoice Status' button I am taken back to the admin invoice show page And I see that my Invoice's status has now been updated" do
        visit admin_invoice_path(@invoice_1)
        select 'In Progress', from: 'Invoice Status'
        click_button "Update Invoice"
        expect(current_path).to eq(admin_invoice_path(@invoice_1))
        expect(page).to have_content("In Progress")
      end

      describe "Show Invoice Revenue" do
        it "Then I see the total revenue that will be generated from this invoice" do
          visit admin_invoice_path(@invoice_1)
          
          within("#invoice-details-#{@invoice_1.id}") do
            expect(page).to have_content((@invoice_1.total_revenue_of_invoice/100.00).to_s(:delimited))
            expect(page).to_not have_content((@invoice_2.total_revenue_of_invoice/100.00).to_s(:delimited))
          end

          visit admin_invoice_path(@invoice_2)

          within("#invoice-details-#{@invoice_2.id}") do
            expect(page).to have_content((@invoice_2.total_revenue_of_invoice/100.00).to_s(:delimited))
            expect(page).to_not have_content((@invoice_1.total_revenue_of_invoice/100.00).to_s(:delimited))
          end
        end

        describe "Revenue from this Invoice after Bulk Discountes " do
          before :each do
            @merchant_1 = create(:merchant)
            @merchant_2 = create(:merchant)
      
            @item_1 = create(:item, name: "item_1", merchant: @merchant_1, active_status: :enabled)
            @item_2 = create(:item, name: "item_2", merchant: @merchant_1)
            @item_3 = create(:item, name: "item_3", merchant: @merchant_1)
            @item_4 = create(:item, name: "item_4", merchant: @merchant_2, active_status: :enabled)
            @item_5 = create(:item, name: "item_5", merchant: @merchant_2, active_status: :enabled)
            
            @invoice_1 = create(:invoice)
            @invoice_2 = create(:invoice)

            create(:invoice_items, invoice: @invoice_1, item: @item_5, unit_price: 1000, quantity: 10) #8000, 10000
            create(:invoice_items, invoice: @invoice_1, item: @item_4, unit_price: 900, quantity: 9) #8100 -no discount
            create(:invoice_items, invoice: @invoice_1, item: @item_3, unit_price: 800, quantity: 8) #3200, 6400

            create(:invoice_items, invoice: @invoice_2, item: @item_2, unit_price: 700, quantity: 7) #3675, 4900
            create(:invoice_items, invoice: @invoice_2, item: @item_1, unit_price: 600, quantity: 6) #2700, 3600

            create_list(:transaction, 1, invoice: @invoice_1, result: :success)
            create_list(:transaction, 1, invoice: @invoice_2, result: :success)

            @discount_1 = create(:discount, discount: 0.25, threshold: 6, merchant: @merchant_1)
            @discount_2 = create(:discount, discount: 0.5, threshold: 8, merchant: @merchant_1)
            @discount_3 = create(:discount, discount: 0.20, threshold: 10, merchant: @merchant_2)
          end

          it 'I see the total revenue for my merchant from this invoice (not including discounts)' do
            visit admin_invoice_path(@invoice_1)
            
            within("#invoice-details-#{@invoice_1.id}") do
              within("#invoice-revenue") do
                expect(page).to have_content((@invoice_1.total_revenue_of_invoice/100.00).to_s(:delimited))
              end
            end

            visit admin_invoice_path(@invoice_2)

            within("#invoice-details-#{@invoice_2.id}") do
              within("#invoice-revenue") do
                expect(page).to have_content((@invoice_2.total_revenue_of_invoice/100.00).to_s(:delimited))
              end
            end
          end

          it " I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
            visit admin_invoice_path(@invoice_1)

            within("#invoice-details-#{@invoice_1.id}") do
              within("#invoice-revenue") do
                expect(page).to have_content((@invoice_1.discounted_revenue_of_invoice/100.00).to_s(:delimited))
              end
            end

            visit admin_invoice_path(@invoice_2)

            within("#invoice-details-#{@invoice_2.id}") do
              within("#invoice-revenue") do
                expect(page).to have_content((@invoice_2.discounted_revenue_of_invoice/100.00).to_s(:delimited))
              end
            end

          end
        end
      end

    end
  end
end