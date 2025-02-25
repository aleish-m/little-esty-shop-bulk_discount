require 'rails_helper'

RSpec.describe "Admin Dashboard" do
  describe "As an admin" do
    describe "I visit the admin dashboard" do
      before :each do
        @merchant_1 = create(:merchant)
        @merchant_2 = create(:merchant) 
        @merchant_3 = create(:merchant) 
    
        @customer_1 = create(:customer)
        @customer_2 = create(:customer)
        @customer_3 = create(:customer)
        @customer_4 = create(:customer)
        @customer_5 = create(:customer)
        @customer_6 = create(:customer)
        @customer_7 = create(:customer)
        @customer_8 = create(:customer)
    
        @invoice_1 = create(:invoice, status: :completed, created_at: "08-10-2022", customer: @customer_1)
        @invoice_2 = create(:invoice, status: :completed, created_at: "09-10-2022", customer: @customer_2)
        @invoice_3 = create(:invoice, status: :completed, created_at: "10-08-2022", customer: @customer_3)
        @invoice_4 = create(:invoice, status: :completed, created_at: "10-06-2022", customer: @customer_4)
        @invoice_5 = create(:invoice, status: :completed, created_at: "10-10-2022", customer: @customer_5)
        @invoice_6 = create(:invoice, status: :completed, created_at: "01-07-2022", customer: @customer_6)
        @invoice_7 = create(:invoice, status: :completed, created_at: "10-09-2022", customer: @customer_7)
        @invoice_8 = create(:invoice, status: :completed, created_at: "10-11-2022", customer: @customer_8)

        # customer_1 transactions
        @transactions_1 = create_list(:transaction, 3, result: :failed, invoice: @invoice_1)
        @transactions_1 = create_list(:transaction, 5, result: :success, invoice: @invoice_1)

        # customer_2 transactions
        @transactions_3 = create_list(:transaction, 1, result: :failed, invoice: @invoice_2)
        @transactions_4 = create_list(:transaction, 7, result: :success, invoice: @invoice_2) 

        # customer_3 transactions
        @transactions_5 = create_list(:transaction, 2, result: :failed, invoice: @invoice_3)
        @transactions_6= create_list(:transaction, 6, result: :success, invoice: @invoice_3)

        # customer_4 transactions
        @transactions_7= create_list(:transaction, 8, result: :success, invoice: @invoice_4)

        # customer_5 transactions
        @transactions_8 = create_list(:transaction, 4, result: :failed, invoice: @invoice_5)

        # customer_6 transactions
        @transactions_9 = create_list(:transaction, 2, result: :failed, invoice: @invoice_6)
        @transactions_10 = create_list(:transaction, 2, result: :success, invoice: @invoice_6)
        
        # customer_7 transactions
        @transactions_11 = create_list(:transaction, 3, result: :failed, invoice: @invoice_7)
        @transactions_12 = create_list(:transaction, 1, result: :success, invoice: @invoice_7)
        
        # customer_8 transactions
        @transactions_14 = create_list(:transaction, 4, result: :success, invoice: @invoice_8)
    
        @item_1 = create(:item, merchant: @merchant_1) 
        @item_2 = create(:item, merchant: @merchant_2)  
        @item_3 = create(:item, merchant: @merchant_3)  
    
        @invoice_item1 = create(:invoice_items, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 2000, status: :packaged)
        @invoice_item2 = create(:invoice_items, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: 1000, status: :pending)
        @invoice_item3 = create(:invoice_items, item_id: @item_2.id, invoice_id: @invoice_3.id, quantity: 4, unit_price: 1000, status: :packaged)
        @invoice_item4 = create(:invoice_items, item_id: @item_3.id, invoice_id: @invoice_4.id, quantity: 2, unit_price: 2500, status: :pending)
        @invoice_item5 = create(:invoice_items, item_id: @item_3.id, invoice_id: @invoice_5.id, quantity: 3, unit_price: 2500, status: :shipped)
      end

      describe "Dashboard Links" do

        it "I see a header indicating that I am on the admin dashboard" do
          visit admin_path

          expect(page).to have_content("Admin Dashboard")
        end

        it "will show a link to the admin merchants index (/admin/merchants)and invoices index (/admin/invoices)" do
          visit admin_path
          
          expect(page).to have_link("Merchant Index")
          expect(page).to have_link("Invoice Index")
        end

        it "will have working links to the merchants" do
          visit admin_path
          click_on "Merchant Index"
          expect(current_path).to eq(admin_merchants_path)
        end

        it "will have working links to the invoice indexs" do
          visit admin_path
          click_on "Invoice Index"
          expect(current_path).to eq(admin_invoices_path)
        end
      end

      describe "Dashboard Customers" do

        it "I see the names of the top 5 customers who have conducted the largest number of successful transactions" do
          visit admin_path

            within("#top-5-customers") do
            expect(page).to have_content("#{@customer_4.first_name} #{@customer_4.last_name}")
            expect(page).to have_content("#{@customer_2.first_name} #{@customer_2.last_name}")
            expect(page).to have_content("#{@customer_3.first_name} #{@customer_3.last_name}")
            expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name}")
            expect(page).to have_content("#{@customer_8.first_name} #{@customer_8.last_name}")
          end
          
          expect(page).to_not have_content("#{@customer_5.first_name} #{@customer_5.last_name}")
          expect(page).to_not have_content("#{@customer_6.first_name} #{@customer_6.last_name}")
          expect(page).to_not have_content("#{@customer_7.first_name} #{@customer_7.last_name}")
        end

        it "Next to each customer name I see the number of successful transactions they have conducted" do
          visit admin_path

          within("#top-5-customers") do
            within("##{@customer_4.id}") do
              expect(page).to have_content("#{@customer_4.invoices.successful_transactions_count}")
              expect(page).to_not have_content("#{@customer_3.invoices.successful_transactions_count}")
            end
            within("##{@customer_2.id}") do
              expect(page).to have_content("#{@customer_2.invoices.successful_transactions_count}")
              expect(page).to_not have_content("#{@customer_3.invoices.successful_transactions_count}")
            end
            within("##{@customer_3.id}") do
              expect(page).to have_content("#{@customer_3.invoices.successful_transactions_count}")
              expect(page).to_not have_content("#{@customer_1.invoices.successful_transactions_count}")
            end
            within("##{@customer_1.id}") do
              expect(page).to have_content("#{@customer_1.invoices.successful_transactions_count}")
              expect(page).to_not have_content("#{@customer_8.invoices.successful_transactions_count}")
            end
            within("##{@customer_8.id}") do
              expect(page).to have_content("#{@customer_8.invoices.successful_transactions_count}")
              expect(page).to_not have_content("#{@customer_4.invoices.successful_transactions_count}")
            end

            expect(page).to_not have_content("#{@customer_5.invoices.successful_transactions_count}")
            expect(page).to_not have_content("#{@customer_6.invoices.successful_transactions_count}")
            expect(page).to_not have_content("#{@customer_7.invoices.successful_transactions_count}")
          end
        end
      end

      describe "Dashboard Invoices" do

        it "will show a section for 'Incomplete Invoices' with a list of the id of all invoices that have items that have not yet shipped" do
          visit admin_path

          within("#incomplete-invoices") do
            expect(page).to have_content("Incomplete Invoices")
            expect(page).to have_content(@invoice_1.id)
            expect(page).to have_content(@invoice_2.id) 
            expect(page).to have_content(@invoice_3.id) 
            expect(page).to have_content(@invoice_4.id)
            expect(page).to_not have_content(@invoice_5.id)
          end
        end

        it "will have incomplete invoice id links to the invoices admin show page" do
          visit admin_path

          within("#incomplete-invoices") do
            click_link "#{@invoice_1.id}"
          end

          expect(current_path).to eq(admin_invoice_path(@invoice_1))

          visit admin_path

          within("#incomplete-invoices") do
            click_link "#{@invoice_4.id}"
          end

          expect(current_path).to eq(admin_invoice_path(@invoice_4))

          visit admin_path
          expect(page).to_not have_link("#{@invoice_5.id}")
        end

        it "Next to each invoice id I see the date that the invoice was created formatted like 'Monday, July 18, 2019'" do
          visit admin_path

          within("#incomplete-invoices") do
            expect(page).to have_content("Saturday, October 08, 2022")
            expect(page).to have_content("Sunday, October 09, 2022")
            expect(page).to have_content("Wednesday, August 10, 2022")
            expect(page).to have_content("Friday, June 10, 2022")
          end
        end 

        it "I see that the list is ordered from oldest to newest" do
          visit admin_path
          within("#incomplete-invoices") do
            expect("Friday, June 10, 2022").to appear_before("Saturday, October 08, 2022")
            expect("Friday, June 10, 2022").to appear_before("Sunday, October 09, 2022")
            expect("Friday, June 10, 2022").to appear_before("Wednesday, August 10, 2022")
            expect("Wednesday, August 10, 2022").to appear_before("Saturday, October 08, 2022")
            expect("Wednesday, August 10, 2022").to appear_before("Sunday, October 09, 2022")
            expect("Saturday, October 08, 2022").to appear_before("Sunday, October 09, 2022")
          end
        end
      end
    end
  end
end