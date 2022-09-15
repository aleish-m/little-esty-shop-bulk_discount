require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'as a merchant' do
    let!(:merchant_1) { Merchant.create!(name: "Johns Tools") }
    let!(:merchant_2) { Merchant.create!(name: "Hannas Hammocks") }
    let!(:pretty_plumbing) { Merchant.create!(name: "Pretty Plumbing") }
    let!(:sink) { pretty_plumbing.items.create!(name: "Super Sink", description: "Super Sink with Superpowers.") }
    let!(:rug) { pretty_plumbing.items.create!(name: "Hall Rug", description: "It's a rug.") }
    let!(:chair) { pretty_plumbing.items.create!(name: "Great Chair", description: "It's an okay chair.") }
    let!(:lamp) { pretty_plumbing.items.create!(name: "Table Lamp", description: "Lamp for tables.") }
    let!(:toilet) { pretty_plumbing.items.create!(name: "XL-Toilet", description: "Big Toilet.") }

    let!(:customer_1) { Customer.create!(first_name: "Larry", last_name: "Smith") }
    let!(:customer_2) { Customer.create!(first_name: "Susan", last_name: "Field") }
    let!(:customer_3) { Customer.create!(first_name: "Barry", last_name: "Roger") }
    let!(:customer_4) { Customer.create!(first_name: "Mary", last_name: "Flower") }
    let!(:customer_5) { Customer.create!(first_name: "Tim", last_name: "Colin") }
    let!(:customer_6) { Customer.create!(first_name: "Harry", last_name: "Dodd") }
    let!(:customer_7) { Customer.create!(first_name: "Molly", last_name: "McMann") }
    let!(:customer_8) { Customer.create!(first_name: "Gary", last_name: "Jone") }

    let!(:invoice_1) { customer_1.invoices.create!(status: 1) }
    let!(:invoice_2) { customer_2.invoices.create!(status: 1) }
    let!(:invoice_3) { customer_3.invoices.create!(status: 1) }
    let!(:invoice_4) { customer_4.invoices.create!(status: 1) }
    let!(:invoice_5) { customer_5.invoices.create!(status: 1) }
    let!(:invoice_6) { customer_6.invoices.create!(status: 1) }
    let!(:invoice_7) { customer_7.invoices.create!(status: 1) }
    let!(:invoice_8) { customer_8.invoices.create!(status: 1) }

    # customer_1 transactions
    let!(:transaction_1) { invoice_1.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_2) { invoice_1.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_3) { invoice_1.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_4) { invoice_1.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_5) { invoice_1.transactions.create!(credit_card_number: "6965074599341776", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_6) { invoice_1.transactions.create!(credit_card_number: "5562017483947471", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_7) { invoice_1.transactions.create!(credit_card_number: "5478972046869861", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_8) { invoice_1.transactions.create!(credit_card_number: "4333324752400785", credit_card_expiration_date: "", result: 0) }
    # customer_2 transactions
    let!(:transaction_9) { invoice_2.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_10) { invoice_2.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_11) { invoice_2.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_12) { invoice_2.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_13) { invoice_2.transactions.create!(credit_card_number: "6965074599341776", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_14) { invoice_2.transactions.create!(credit_card_number: "9626688955535156", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_15) { invoice_2.transactions.create!(credit_card_number: "0672614265387781", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_16) { invoice_2.transactions.create!(credit_card_number: "3141635535272083", credit_card_expiration_date: "", result: 0) }
    # customer_3 transactions
    let!(:transaction_17) { invoice_3.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_18) { invoice_3.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_19) { invoice_3.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_20) { invoice_3.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_21) { invoice_3.transactions.create!(credit_card_number: "6965074599341776", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_22) { invoice_3.transactions.create!(credit_card_number: "9626688955535156", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_23) { invoice_3.transactions.create!(credit_card_number: "0672614265387781", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_24) { invoice_3.transactions.create!(credit_card_number: "3141635535272083", credit_card_expiration_date: "", result: 1) }
    # customer_4 transactions
    let!(:transaction_25) { invoice_4.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_26) { invoice_4.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_27) { invoice_4.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_28) { invoice_4.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_29) { invoice_4.transactions.create!(credit_card_number: "6965074599341776", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_30) { invoice_4.transactions.create!(credit_card_number: "9626688955535156", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_31) { invoice_4.transactions.create!(credit_card_number: "0672614265387781", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_32) { invoice_4.transactions.create!(credit_card_number: "3141635535272083", credit_card_expiration_date: "", result: 0) }
    # customer_5 transactions
    let!(:transaction_33) { invoice_5.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_34) { invoice_5.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_35) { invoice_5.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_36) { invoice_5.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 1) }
    # customer_6 transactions
    let!(:transaction_37) { invoice_6.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_38) { invoice_6.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_39) { invoice_6.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_40) { invoice_6.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 1) }
    # customer_7 transactions
    let!(:transaction_41) { invoice_7.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_42) { invoice_7.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_43) { invoice_7.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 1) }
    let!(:transaction_44) { invoice_7.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 1) }
    # customer_8 transactions
    let!(:transaction_45) { invoice_8.transactions.create!(credit_card_number: "0657559737742582", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_46) { invoice_8.transactions.create!(credit_card_number: "4597070635635151", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_47) { invoice_8.transactions.create!(credit_card_number: "2020066659240113", credit_card_expiration_date: "", result: 0) }
    let!(:transaction_48) { invoice_8.transactions.create!(credit_card_number: "8860016236091988", credit_card_expiration_date: "", result: 0) }

    let!(:invoice_item_1) { InvoiceItem.create!(item_id: "#{sink.id}", invoice_id: "#{invoice_1.id}", status: 2) }
    let!(:invoice_item_2) { InvoiceItem.create!(item_id: "#{rug.id}", invoice_id: "#{invoice_1.id}", status: 2) }
    let!(:invoice_item_3) { InvoiceItem.create!(item_id: "#{chair.id}", invoice_id: "#{invoice_1.id}", status: 2) }
    let!(:invoice_item_4) { InvoiceItem.create!(item_id: "#{lamp.id}", invoice_id: "#{invoice_1.id}", status: 0) }
    let!(:invoice_item_5) { InvoiceItem.create!(item_id: "#{toilet.id}", invoice_id: "#{invoice_1.id}", status: 0) }

    let!(:invoice_item_6) { InvoiceItem.create!(item_id: "#{sink.id}", invoice_id: "#{invoice_2.id}", status: 0) }
    let!(:invoice_item_7) { InvoiceItem.create!(item_id: "#{rug.id}", invoice_id: "#{invoice_2.id}", status: 1) }
    let!(:invoice_item_8) { InvoiceItem.create!(item_id: "#{chair.id}", invoice_id: "#{invoice_2.id}", status: 2) }
    let!(:invoice_item_9) { InvoiceItem.create!(item_id: "#{lamp.id}", invoice_id: "#{invoice_2.id}", status: 2) }
    let!(:invoice_item_10) { InvoiceItem.create!(item_id: "#{toilet.id}", invoice_id: "#{invoice_2.id}", status: 2) }

    describe 'User Story 1' do

        # As a merchant,
        # When I visit my merchant dashboard (/merchants/merchant_id/dashboard)
        # Then I see the name of my merchant

      it 'then I see the name of the merchant' do

        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(page).to have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_2.name)

        visit "/merchants/#{merchant_2.id}/dashboard"

        expect(page).to have_content(merchant_2.name)
        expect(page).to_not have_content(merchant_1.name)
      end
    end

    describe 'User Story 2' do

      # As a merchant,
      # When I visit my merchant dashboard
      # Then I see link to my merchant items index (/merchants/merchant_id/items)
      # And I see a link to my merchant invoices index (/merchants/merchant_id/invoices)

      it 'Then I see link to my merchant items index (/merchants/merchant_id/items)' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(find_link('Items Index')[:href].should == "/merchants/#{merchant_1.id}/items")

        visit "/merchants/#{merchant_2.id}/dashboard"

        expect(find_link('Items Index')[:href].should == "/merchants/#{merchant_2.id}/items")
      end

      it 'And I see a link to my merchant invoices index (/merchants/merchant_id/invoices)' do
        visit "/merchants/#{merchant_1.id}/dashboard"

        expect(find_link('Invoices Index')[:href].should == "/merchants/#{merchant_1.id}/invoices")

        visit "/merchants/#{merchant_2.id}/dashboard"

        expect(find_link('Invoices Index')[:href].should == "/merchants/#{merchant_2.id}/invoices")
      end
    end

    describe 'User Story 3' do
      # As a merchant,
      # When I visit my merchant dashboard
      # Then I see the names of the top 5 customers
      # who have conducted the largest number of successful transactions with my merchant
      # And next to each customer name I see the number of successful transactions they have
      # conducted with my merchant

      it 'Then I see the names of the top 5 customers that have conducted transactions with merchant' do
        
        sink.invoices << invoice_1
        sink.invoices << invoice_2
        sink.invoices << invoice_3
        sink.invoices << invoice_4
        sink.invoices << invoice_5
        sink.invoices << invoice_6
        sink.invoices << invoice_7
        sink.invoices << invoice_8
    
        visit "/merchants/#{pretty_plumbing.id}/dashboard"
        save_and_open_page
        expect(page).to have_content(customer_4.first_name)
        expect(page).to have_content(customer_2.first_name)
        expect(page).to have_content(customer_3.first_name)
        expect(page).to have_content(customer_1.first_name)
        expect(page).to have_content(customer_8.first_name)
        expect(page).to have_content(customer_4.last_name)
        expect(page).to have_content(customer_2.last_name)
        expect(page).to have_content(customer_3.last_name)
        expect(page).to have_content(customer_1.last_name)
        expect(page).to have_content(customer_8.last_name)
        expect(page).to_not have_content(customer_5.first_name)
        expect(page).to_not have_content(customer_6.first_name)
        expect(page).to_not have_content(customer_7.first_name)
        expect(page).to_not have_content(customer_5.last_name)
        expect(page).to_not have_content(customer_6.last_name)
        expect(page).to_not have_content(customer_7.last_name)

      end

      it 'And next to each customer name I see the number of successful transactions they have with merchant' do

        sink.invoices << invoice_1
        sink.invoices << invoice_2
        sink.invoices << invoice_3
        sink.invoices << invoice_4
        sink.invoices << invoice_5
        sink.invoices << invoice_6
        sink.invoices << invoice_7
        sink.invoices << invoice_8

        visit "/merchants/#{pretty_plumbing.id}/dashboard"

        expect(page).to have_content("Successful Transactions: 42")
        expect(page).to have_content("Successful Transactions: 30")
        expect(page).to have_content("Successful Transactions: 8")
        expect(page).to have_content("Successful Transactions: 6")
        expect(page).to have_content("Successful Transactions: 4")
        expect(page).to_not have_content("Successful Transactions: 10")
      end
    end

    # As a merchant
    # When I visit my merchant dashboard
    # Then I see a section for "Items Ready to Ship"
    # In that section I see a list of the names of all of my items that
    # have been ordered and have not yet been shipped,
    # And next to each Item I see the id of the invoice that ordered my item
    # And each invoice id is a link to my merchant's invoice show page

    describe 'User Story 4' do
      it 'Then I see a section for Items Ready to Ship' do

        sink.invoices << invoice_1
        sink.invoices << invoice_2
        sink.invoices << invoice_3
        sink.invoices << invoice_4
        sink.invoices << invoice_5
        sink.invoices << invoice_6
        sink.invoices << invoice_7
        sink.invoices << invoice_8

        visit "/merchants/#{pretty_plumbing.id}/dashboard"
        
        expect(page).to have_content("Items Ready to Ship:")

      end

      it 'In that section I see a list of the names of all of my items that have been ordered and have not yet been shipped' do
        visit "/merchants/#{pretty_plumbing.id}/dashboard"
        
        expect(page).to have_content(lamp.name)
        expect(page).to have_content(toilet.name)
        expect(page).to have_content(sink.name)
        expect(page).to have_content(rug.name)
        expect(page).to_not have_content(chair.name)
      end

      it '' do

      end

      it '' do
        
      end
    end
  end
end