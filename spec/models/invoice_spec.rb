require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(["in progress", :completed, :cancelled]) }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:discounts).through(:merchants) }
  end

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
    @invoice_3 = create(:invoice, status: :cancelled, created_at: "10-08-2022", customer: @customer_3)
    @invoice_4 = create(:invoice, status: :completed, created_at: "10-08-2022", customer: @customer_4)
    @invoice_2 = create(:invoice, status: :cancelled, created_at: "08-10-2022", customer: @customer_2)
    @invoice_5 = create(:invoice, status: :completed, created_at: "10-08-2022", customer: @customer_5)
    @invoice_6 = create(:invoice, status: :completed, created_at: "01-07-2022", customer: @customer_6)
    @invoice_7 = create(:invoice, status: :completed, created_at: "01-07-2022", customer: @customer_7)
    @invoice_8 = create(:invoice, status: :completed, created_at: "01-07-2022", customer: @customer_8)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
    @item_3 = create(:item, merchant: @merchant_3)

    @invoice_item1 = create(:invoice_items, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 2000, status: :packaged)
    @invoice_item2 = create(:invoice_items, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: 1000, status: :pending)
    @invoice_item3 = create(:invoice_items, item_id: @item_2.id, invoice_id: @invoice_3.id, quantity: 4, unit_price: 1000, status: :shipped)
    @invoice_item4 = create(:invoice_items, item_id: @item_3.id, invoice_id: @invoice_4.id, quantity: 2, unit_price: 2500, status: :pending)
    @invoice_item5 = create(:invoice_items, item_id: @item_3.id, invoice_id: @invoice_5.id, quantity: 3, unit_price: 2500, status: :shipped)
    @invoice_item6 = create(:invoice_items, item_id: @item_3.id, invoice_id: @invoice_5.id, quantity: 3, unit_price: 2500, status: :packaged)

    @transactions_1 = create_list(:transaction, 3, result: :failed, invoice: @invoice_1)
    @transactions_2 = create_list(:transaction, 5, result: :success, invoice: @invoice_1)

    @transactions_3 = create_list(:transaction, 1, result: :failed, invoice: @invoice_2)
    @transactions_4 = create_list(:transaction, 7, result: :success, invoice: @invoice_2)
  end

  describe "class methods" do

    it '#unshipped_invoices' do
      expect(Invoice.unshipped_invoices).to include(@invoice_1, @invoice_2, @invoice_4, @invoice_5)
    end

    it '#successful_transactions_count' do
      expect(Invoice.successful_transactions_count).to eq(12)
    end

    it "#sort_by_date" do
      expect(Invoice.sort_by_date).to eq([@invoice_8, @invoice_7, @invoice_6, @invoice_5, @invoice_3, @invoice_4, @invoice_1, @invoice_2])
    end

    it "#best_day" do
      expect(Invoice.best_day.created_at).to eq(@invoice_8.created_at)
    end
  end

  describe "instance methods" do 
    it "#total_revenue_of_invoice" do
      expect(@invoice_1.total_revenue_of_invoice).to be (50000)
    end

    describe "#discount_amount" do
      before :each do
        @merchant_1 = create(:merchant)
        @merchant_2 = create(:merchant)
      
        @item_1 = create(:item, name: "item_1", merchant: @merchant_1)
        @item_2 = create(:item, name: "item_2", merchant: @merchant_1)
        @item_3 = create(:item, name: "item_3", merchant: @merchant_1)
        @item_4 = create(:item, name: "item_4", merchant: @merchant_1)
        @item_5 = create(:item, name: "item_5", merchant: @merchant_1)

        @item_6 = create(:item, name: "item_6", merchant: @merchant_2)
        @item_7 = create(:item, name: "item_7", merchant: @merchant_2)
        
        @invoice_1 = create(:invoice)
        @invoice_2 = create(:invoice)

        @discount_1 = create(:discount, discount: 0.25, threshold: 7, merchant: @merchant_1)
        @discount_2 = create(:discount, discount: 0.5, threshold: 8, merchant: @merchant_1)
        @discount_3 = create(:discount, discount: 0.20, threshold: 10, merchant: @merchant_1)
      end

      it "calculates the highest discount avalible for each item on ivoice and addes it together" do 
        invoice_3 = create(:invoice)
        create(:invoice_items, invoice: invoice_3, item: @item_5, unit_price: 100, quantity: 7) #700 w/o discount - 175 amount of discounted applied to item
        create(:invoice_items, invoice: invoice_3, item: @item_4, unit_price: 100, quantity: 8) #800 w/o discount - 400 amount of discounted applied to item
        
        expect(invoice_3.discount_amount).to eq(575)
        
      end
      
      it "it only calculates a discount on items that meet the threshold for the discount" do 
        invoice_4 = create(:invoice)
        create(:invoice_items, invoice: invoice_4, item: @item_5, unit_price: 100, quantity: 7) #700 w/o discount - 175 amount of discounted applied to item
        create(:invoice_items, invoice: invoice_4, item: @item_4, unit_price: 100, quantity: 5) #500 no discount

        expect(invoice_4.discount_amount).to eq(175)
      end
    end

    describe "#discounted_revenue_of_invoice" do
      before :each do
        @merchant_1 = create(:merchant)
        @merchant_2 = create(:merchant)
      
        @item_1 = create(:item, name: "item_1", merchant: @merchant_1)
        @item_2 = create(:item, name: "item_2", merchant: @merchant_1)
        @item_3 = create(:item, name: "item_3", merchant: @merchant_1)
        @item_4 = create(:item, name: "item_4", merchant: @merchant_1)
        @item_5 = create(:item, name: "item_5", merchant: @merchant_1)

        @item_6 = create(:item, name: "item_6", merchant: @merchant_2)
        @item_7 = create(:item, name: "item_7", merchant: @merchant_2)
        
        @invoice_1 = create(:invoice)
        @invoice_2 = create(:invoice)

        create(:invoice_items, invoice: @invoice_1, item: @item_5, unit_price: 1000, quantity: 10) #5000, 10000
        create(:invoice_items, invoice: @invoice_1, item: @item_4, unit_price: 900, quantity: 9) #4050, 8100
        create(:invoice_items, invoice: @invoice_1, item: @item_3, unit_price: 800, quantity: 8) #3200, 6400

        create(:invoice_items, invoice: @invoice_2, item: @item_2, unit_price: 700, quantity: 7) #3675, 4900
        create(:invoice_items, invoice: @invoice_2, item: @item_1, unit_price: 600, quantity: 6) #3600, 3600
        create(:invoice_items, invoice: @invoice_2, item: @item_6, unit_price: 500, quantity: 5) #2500
        create(:invoice_items, invoice: @invoice_2, item: @item_7, unit_price: 400, quantity: 4) #1600

        create_list(:transaction, 1, invoice: @invoice_1, result: :success)
        create_list(:transaction, 1, invoice: @invoice_1, result: :failed)
        create_list(:transaction, 1, invoice: @invoice_2, result: :failed)
        create_list(:transaction, 1, invoice: @invoice_2, result: :success)

        @discount_1 = create(:discount, discount: 0.25, threshold: 7, merchant: @merchant_1)
        @discount_2 = create(:discount, discount: 0.5, threshold: 8, merchant: @merchant_1)
        @discount_3 = create(:discount, discount: 0.20, threshold: 10, merchant: @merchant_1)
      end

      it "Bulk discounts for one merchant should not affect items sold by another merchant" do
        expect(@invoice_2.discounted_revenue_of_invoice).to eq(11375)
      end

      it "The quantities of items ordered cannot be added together to meet the quantity thresholds" do
        invoice_3 = create(:invoice)
        create(:invoice_items, invoice: invoice_3, item: @item_5, unit_price: 1000, quantity: 5) #5000
        create(:invoice_items, invoice: invoice_3, item: @item_4, unit_price: 900, quantity: 5) #4500
        create(:transaction, invoice: invoice_3, result: :success)

        expect(invoice_3.discounted_revenue_of_invoice).to eq(invoice_3.total_revenue_of_invoice)
      end

      it "If an item meets the quantity threshold for multiple bulk discounts, only the one with the greatest percentage discount should be applied" do
        expect(@invoice_1.discounted_revenue_of_invoice).to eq(12250)
      end

      it "If the quantity of an item ordered meets or exceeds the quantity threshold, then the percentage discount should apply to that item only. Other items that did not meet the quantity threshold will not be affected." do
        invoice_4 = create(:invoice) #total invoice w/o discount 1200
        create(:invoice_items, invoice: invoice_4, item: @item_5, unit_price: 100, quantity: 7) #700 w/o discount - 525 discounted amount (175)
        create(:invoice_items, invoice: invoice_4, item: @item_4, unit_price: 100, quantity: 5) #500 no discount
        expect(invoice_4.discounted_revenue_of_invoice).to eq(1025)
      end
    end
  end
end
