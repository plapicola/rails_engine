require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do

  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'class methods' do
    before :each do
      @merchant_1, @merchant_2, @merchant_3, @merchant_4 = create_list(:merchant, 4)
      @invoice_1, @invoice_2 = create_list(:invoice, 2, merchant: @merchant_1)
      @invoice_3 = create(:invoice, merchant: @merchant_2)
      @invoice_4 = create(:invoice, merchant: @merchant_3)
      @large_unpaid_invoice = create(:invoice, merchant: @merchant_4)
      @invoice_1.invoice_items = create_list(:invoice_item, 3)
      @invoice_2.invoice_items = create_list(:invoice_item, 5)
      @invoice_3.invoice_items = create_list(:invoice_item, 12)
      @invoice_4.invoice_items = create_list(:invoice_item, 4)
      @large_unpaid_invoice.invoice_items = create_list(:invoice_item, 20)
      @invoice_1.transactions << create(:transaction, invoice: @invoice_1)
      @invoice_2.transactions << create(:failed_transaction, invoice: @invoice_2)
      @invoice_3.transactions << create(:transaction, invoice: @invoice_3)
      @invoice_4.transactions << create(:transaction, invoice: @invoice_4)
    end

    describe 'top_by_revenue(limit)' do
      it 'returns the top X merchants by revenue' do
        expect(Merchant.top_by_revenue(1)).to eq([@merchant_2])
        expect(Merchant.top_by_revenue(3)).to eq([@merchant_2, @merchant_3, @merchant_1])
      end
    end

    describe 'top_by_items(limit)' do
      it 'returns the top X merchants by items sold' do
        expect(Merchant.top_by_items(1)).to eq([@merchant_2])
        expect(Merchant.top_by_items(3)).to eq([@merchant_2, @merchant_3, @merchant_1])
      end
    end

    describe 'revenue_for_day(date)' do
      it 'returns the total revenue for the provided date' do
        today = 0.days.ago.strftime("%F")
        five_days_ago = 5.days.ago.strftime("%F")
        old_invoice = create(:invoice, merchant: @merchant_1, created_at: 5.days.ago)
        old_invoice.invoice_items = create_list(:invoice_item, 3)
        old_invoice.transactions << create(:transaction, invoice: old_invoice)

        expect(Merchant.revenue_for_day(today).total_revenue).to eq(0.19)
        expect(Merchant.revenue_for_day(five_days_ago).total_revenue).to eq(0.03)
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant_1, @merchant_2 = create_list(:merchant, 2)
      @invoice_1, @invoice_2 = create_list(:invoice, 2, merchant: @merchant_1)
      @invoice_3 = create(:invoice, merchant: @merchant_2)
      @unpaid_invoice = create(:invoice, merchant: @merchant_1)
      @invoice_1.invoice_items = create_list(:invoice_item, 3)
      @invoice_2.invoice_items = create_list(:invoice_item, 5)
      @invoice_3.invoice_items = create_list(:invoice_item, 12)
      @unpaid_invoice.invoice_items = create_list(:invoice_item, 5)
      @invoice_1.transactions << create(:transaction, invoice: @invoice_1)
      @invoice_2.transactions << create(:failed_transaction, invoice: @invoice_2)
      @invoice_3.transactions << create(:transaction, invoice: @invoice_3)
    end

    describe 'revenue' do
      it 'returns a total_revenue for a merchant' do
        expect(@merchant_1.revenue.total_revenue).to eq(0.03)
      end
    end
  end
end
