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

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end

    it 'can find by customer_id' do
      get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["customer_id"]).to eq(@item.customer_id)
    end

    it 'can find by merchant_id' do
      get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["merchant_id"]).to eq(@item.merchant_id)
    end

    it 'can find by invoice status' do
      get "/api/v1/invoices/find?status=#{@invoice.status}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["status"]).to eq(@item.status)
    end

    it 'can find by created_at' do
      get "/api/v1/invoices/find?created_at=#{@created_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoices/find?updated_at=#{@updated_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
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
      expect(invoice["attributes"]["id"]).to eq(@invoice_1.id)
    end

    it 'can find by customer_id' do
      get "/api/v1/invoices/find_all?customer_id=#{@invoice_1.customer_id}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["customer_id"]).to eq(@customer.id)
      expect(invoices[1]["attributes"]["customer_id"]).to eq(@customer.id)
    end

    it 'can find by merchant_id' do
      get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices["attributes"]["merchant_id"]).to eq(@merchant.id)
      expect(invoices["attributes"]["merchant_id"]).to eq(@merchant.id)
    end

    it 'can find by status' do
      get "/api/v1/invoices/find_all?status=#{@invoice_1.status}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.lenth).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@invoice_1.id)
      expect(invoices[2]["attributes"]["id"]).to eq(@invoice_3.id)
    end

    it 'can find by created_at' do
      get "/api/v1/invoices/find_all?created_at=#{@created_at}"

      invoices = JSON.parse(response.body)["data"]

      expecr(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@inovice_1.id)
      expect(invoices[1]["attributes"]["id"]).to eq(@inovice_3.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoices/find_all?created_at=#{@updated_at}"

      invoices = JSON.parse(response.body)["data"]

      expecr(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["attributes"]["id"]).to eq(@inovice_1.id)
      expect(invoices[1]["attributes"]["id"]).to eq(@inovice_2.id)
    end
  end

  describe 'relationships' do
  end
end
