require 'rails_helper'

describe 'Transactions API' do
  it 'can send all transactions' do
    transaction_1, transaction_2, transaction_3 = create_list(:transaction, 3)

    get "/api/v1/transactions"

    transactions = JSON.parse(repsonse.body)["data"]

    expect(response).to be_successful
    expect(transactions.length).to eq(3)
    expect(transactions[0]["attributes"]["id"]).to eq(transaction_1.id)
    expect(transactions[1]["attributes"]["id"]).to eq(transaction_2.id)
    expect(transactions[2]["attributes"]["id"]).to eq(transaction_3.id)
  end

  it 'can send a single transaction' do
    transaction = create(:transaction)

    get "/api/v1/transactions/#{transaction.id}"

    transaction = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(transaction["attributes"]["id"]).to eq(transaction.id)
  end

  it 'can send a random transaction' do
    transaction_1, transaction_2 = create_list(:transaction, 2)

    get "/api/v1/transactions/random"

    transaction = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(transaction["attributes"]["id"]).to eq(transaction_1.id).or(eq(transaction_2.id))
  end

  describe 'finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @transaction = create(:transaction, created_at: @created_at, updated_at: @updated_at)
    end

    it 'can find by id' do
      get "/api/v1/transactions/find?id=#{@transaction.id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["id"]).to eq(@transaction.id)
    end

    it 'can find by invoice_id' do
      get "/api/v1/transactions/find?invoice_id=#{@transaction.invoice_id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["invoice_id"]).to eq(@transaction.invoice_id)
    end

    it 'can find by credit card number' do
      get "/api/v1/transactions/find?credit_card_number=#{@transaction.credit_card_number}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["credit_card_number"]).to eq(@transaction.credit_card_number.to_s)
    end

    it 'can find by credit card expiration date' do
      get "/api/v1/transactions/find?credit_card_expiration_date=#{@transaction.credit_card_expiration_date}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["id"]).to eq(@transaction.id)
    end

    it 'can find by result' do
      get "/api/v1/transactions/find?result=#{@transaction.result}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["result"]).to eq(@transaction.result)
    end

    it 'can find by created_at' do
      get "/api/v1/transactions/find?created_at=#{@created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["id"]).to eq(@transaction.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/transactions/find?created_at=#{@created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["id"]).to eq(@transaction.id)
    end
  end

  describe 'multi-finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @invoice = create(:invoice)
      @transaction_1 = create(:transaction, created_at: @created_at, updated_at: @updated_at)
      @transaction_2 = create(:failed_transaction, created_at: @created_at, credit_card_number: 1234567890123456, invoice: @invoice)
      @transaction_3 = create(:transaction, updated_at: @updated_at, credit_card_number: 1234567890123456, invoice: @invoice)
    end

    it 'can find by id' do
      get "/api/v1/transactions/find_all?id=#{@transaction_1.id}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(1)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_1.id)
    end

    it 'can find by invoice_id' do
      get "/api/v1/transactions/find_all?invoice_id=#{@transaction_2.invoice_id}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_2.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_3.id)
    end

    it 'can find by credit card number' do
      get "/api/v1/transactions/find_all?credit_card_number=#{@transaction_2.credit_card_number}"

      transactions = JSON.parse(repsonse.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_2.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_3.id)
    end

    it 'can find by credit card expiration date' do
      get "/api/v1/transactions/find_all?credit_card_expiration_date=#{@transaction_1.credit_card_expiration_date}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(3)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_1.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_2.id)
      expect(transactions[2]["attributes"]["id"]).to eq(@transaction_3.id)
    end

    it 'can find by result' do
      get "/api/v1/transactions/find_all?result=#{@transaction_2.result}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions.length).to eq(1)
      expect(transactions[0]["attribtes"]["id"]).to eq(@transaction_2.id)
    end

    it 'can find by created_at' do
      get "/api/v1/transactions/find_all?created_at=#{@created_at}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_1.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_2.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/transactions/find_all?updated_at=#{@updated_at}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_1.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_3.id)
    end
  end

  describe 'relationships' do
    before :each do
      @invoice = create(:invoice)
      @transaction = create(:transaction, invoice: @invoice)
    end

    it 'can return the invoice' do
      get "/api/v1/transactions/#{@transaction.id}/invoice"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attributes"]["id"]).to eq(@invoice.id)
    end
  end
end
