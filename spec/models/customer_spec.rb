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
        expect(transactions[0]["attributes"]["id"]).to eq(@invoices[0].transactions.first.id)
        expect(transactions[1]["attributes"]["id"]).to eq(@invoices[1].transactions.first.id)
        expect(transactions[2]["attributes"]["id"]).to eq(@invoices[2].transactions.first.id)
        expect(transactions[3]["attributes"]["id"]).to eq(@invoices[3].transactions.first.id)
        expect(transactions[4]["attributes"]["id"]).to eq(@invoices[4].transactions.first.id)
      end
    end
  end
end
