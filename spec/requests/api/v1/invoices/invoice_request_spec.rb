require 'rails_helper'

describe 'Invoices API' do
  it 'can send all invoices in the system' do
    invoice_1, invoice_2, invoice_3 = create_list(:invoice, 3)

    get '/api/v1/invoices'

    invoices = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoices.length).to eq(3)
    expect(invoices[0]["attributes"]["id"]).to eq(invoice_1.id)
    expect(invoices[1]["attributes"]["id"]).to eq(invoice_2.id)
    expect(invoices[2]["attributes"]["id"]).to eq(invoice_3.id)
  end

  it 'can send an invoice by id' do
    invoice = create(:invoice)

    get "/api/v1/invoices/#{invoice.id}"

    found_invoice = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(found_invoice["attributes"]["id"]).to eq(invoice.id)
  end

  it 'can return a random invoice' do
    invoice_1, invoice_2 = create_list(:invoice, 2)

    get '/api/v1/invoices/random'

    found_invoice = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(found_invoice["attributes"]["id"]).to eq(invoice_1.id).or(eq(invoice_2.id))
  end

  describe 'finder' do
    before :each do
      @created_at = 5.days.ago.strftime("%F %T UTC")
      @updated_at = 5.days.ago.strftime("%F %T UTC")
      @invoice = create(:invoice, created_at: @created_at, updated_at: @updated_at)
    end

    it 'can find by id' do
      get "/api/v1/invoices/find?id=#{@invoice.id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attributes"]["id"]).to eq(@invoice.id)
    end

    it 'can find by customer_id' do
      get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attributes"]["customer_id"]).to eq(@invoice.customer_id)
    end

    it 'can find by merchant_id' do
      get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["merchant_id"]).to eq(@invoice.merchant_id)
    end

    it 'can find by invoice status' do
      get "/api/v1/invoices/find?status=#{@invoice.status}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["status"]).to eq(@invoice.status)
    end

    it 'can find by created_at' do
      get "/api/v1/invoices/find?created_at=#{@created_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attributes"]["id"]).to eq(@invoice.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoices/find?updated_at=#{@updated_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attributes"]["id"]).to eq(@invoice.id)
    end
  end

  describe 'multi-finder' do
    before :each do
      @customer = create(:customer)
      @merchant = create(:merchant)
      @created_at = 5.days.ago.strftime("%F %T UTC")
      @updated_at = 5.days.ago.strftime("%F %T UTC")
      @invoice_1 = create(:invoice, created_at: @created_at, updated_at: @updated_at, merchant: @merchant)
      @invoice_2 = create(:unshipped_invoice, updated_at: @updated_at, customer: @customer)
      @invoice_3 = create(:invoice, created_at: @created_at, customer: @customer, merchant: @merchant)
    end

    it 'can find by id' do
      get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice[0]["attributes"]["id"]).to eq(@invoice_1.id)
    end

    it 'can find by customer_id' do
      get "/api/v1/invoices/find_all?customer_id=#{@invoice_2.customer_id}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["customer_id"]).to eq(@customer.id)
      expect(invoices[1]["attributes"]["customer_id"]).to eq(@customer.id)
    end

    it 'can find by merchant_id' do
      get "/api/v1/invoices/find_all?merchant_id=#{@invoice_1.merchant_id}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["merchant_id"]).to eq(@merchant.id)
      expect(invoices[1]["attributes"]["merchant_id"]).to eq(@merchant.id)
    end

    it 'can find by status' do
      get "/api/v1/invoices/find_all?status=#{@invoice_1.status}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@invoice_1.id)
      expect(invoices[1]["attributes"]["id"]).to eq(@invoice_3.id)
    end

    it 'can find by created_at' do
      get "/api/v1/invoices/find_all?created_at=#{@created_at}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@invoice_1.id)
      expect(invoices[1]["attributes"]["id"]).to eq(@invoice_3.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoices/find_all?updated_at=#{@updated_at}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@invoice_1.id)
      expect(invoices[1]["attributes"]["id"]).to eq(@invoice_2.id)
    end
  end

  describe 'relationships' do
    before :each do
      @merchant = create(:merchant)
      @customer = create(:customer)
      @item = create(:item, merchant: @merchant)
      @invoice = create(:invoice, customer: @customer, merchant: @merchant)
      @invoice_item_1, @invoice_item_2 = create_list(:invoice_item, 2, invoice: @invoice, item: @item)
      @transaction_1 = create(:failed_transaction, invoice: @invoice)
      @transaction_2 = create(:transaction, invoice: @invoice)
    end

    it 'it can return all transactions' do
      get "/api/v1/invoices/#{@invoice.id}/transactions"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["attributes"]["id"]).to eq(@transaction_1.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@transaction_2.id)
    end

    it 'it can return all invoice_items' do
      get "/api/v1/invoices/#{@invoice.id}/invoice_items"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items.length).to eq(2)
      expect(invoice_items[0]["attributes"]["id"]).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["attributes"]["id"]).to eq(@invoice_item_2.id)
    end

    it 'it can return all items' do
      other_item = create(:item)
      get "/api/v1/invoices/#{@invoice.id}/items"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(1)
      expect(items[0]["attributes"]["id"]).to eq(@item.id)
    end

    it 'it can return the customer' do
      get "/api/v1/invoices/#{@invoice.id}/customer"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["id"]).to eq(@customer.id)
    end

    it 'it can return the merchant' do
      get "/api/v1/invoices/#{@invoice.id}/merchant"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["attributes"]["id"]).to eq(@merchant.id)
    end
  end
end
