require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do

  end

  describe 'relationships' do
    it {should have_many :invoices}
  end

  describe 'instance methods' do
    describe '.transactions' do
      it 'returns transactions for the customer' do
        customer = create(:customer)
        invoices = create_list(:invoice, 5, customer: customer)
        invoices.each do |invoice|
          invoice.transactions << create(:transaction, invoice: invoice)
        end

        transactions = customer.transactions

        expect(transactions.length).to eq(5)
        expect(transactions[0].id).to eq(invoices[0].transactions.first.id)
        expect(transactions[1].id).to eq(invoices[1].transactions.first.id)
        expect(transactions[2].id).to eq(invoices[2].transactions.first.id)
        expect(transactions[3].id).to eq(invoices[3].transactions.first.id)
        expect(transactions[4].id).to eq(invoices[4].transactions.first.id)
      end
    end

    describe '.favorite_merchant' do
      before :each do
        @customer = create(:customer)
        @merchant_1, @merchant_2 = create_list(:merchant, 2)
        @successful_invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer)
        @successful_invoice_2 = create(:invoice, merchant: @merchant_1, customer: @customer)
        @successful_invoice_3 = create(:invoice, merchant: @merchant_2, customer: @customer)
        @unsuccessful_invoice = create(:invoice, merchant: @merchant_2, customer: @customer)
        @unpaid_invoice = create(:invoice, merchant: @merchant_2, customer: @customer)
        @successful_invoice_1.transactions << create(:transaction, invoice: @successful_invoice_1)
        @successful_invoice_2.transactions << create(:transaction, invoice: @successful_invoice_2)
        @successful_invoice_3.transactions << create(:transaction, invoice: @successful_invoice_3)
        @unsuccessful_invoice.transactions << create(:failed_transaction, invoice: @unsuccessful_invoice)
      end

      it 'returns the merchant that the customer has had the most successful transactions with' do
        expect(@customer.favorite_merchant).to eq(@merchant_1)
      end
    end
  end
end
