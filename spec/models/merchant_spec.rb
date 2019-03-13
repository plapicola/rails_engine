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
      @invoice_1.update(invoice_items: create_list(:invoice_item, 3))
      @invoice_2.update(invoice_items: create_list(:invoice_item, 5))
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
  end
end
