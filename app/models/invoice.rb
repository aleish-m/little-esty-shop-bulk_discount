class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: { "in progress": 0, completed: 1, cancelled: 2 }

  def self.unshipped_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: 2})
    .distinct
  end

  def self.successful_transactions_count
    sum do |invoice|
      invoice.transactions.where(result: 0).count
    end
  end

  def self.sort_by_date
    order(:created_at)
  end

  def self.best_day
    where(invoices: {status: :completed})
    .group(:id)
    .select('invoices.created_at, invoices.id, count(invoices.id) as sales')
    .order('sales desc, created_at')
    .first
  end

    def total_revenue_of_invoice
      items.total_revenue_of_all_items
    end

    def discount_amount
      items.joins(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.threshold').group(:id).maximum('(invoice_items.quantity * invoice_items.unit_price * discounts.discount)').sum{|x,y| y}

      # items.joins(:invoice_items, :discounts).where('invoice_items.quantity >= discounts.threshold').group(:id).select('items.*, max(invoice_items.quantity * invoice_items.unit_price * discounts.discount) as discount_amount').sum(&:discount_amount)
    end

    def discounted_revenue_of_invoice
      if discount_amount != nil
        total_revenue_of_invoice - discount_amount
      else
        total_revenue_of_invoice
      end
    end
    
end
