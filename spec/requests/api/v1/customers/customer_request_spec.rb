require 'rails_helper'

describe 'Customer API' do
  it 'can return a list of all customers' do
    customer_1, customer_2, customer_3 = create_list(:customer, 3)

    get '/api/v1/customers'

    customers = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(customers.length).to eq(3)
    expect(customers[0]["attributes"]["id"]).to eq(customer_1.id)
  end

  it 'can return a customer by id' do
    new_customer = create(:customer)

    get "/api/v1/customers/#{new_customer.id}"

    customer = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(customer["attributes"]["id"]).to eq(new_customer.id)
  end

  it 'can return a random customer' do
    customer_1, customer_2= create_list(:customer, 2)

    get '/api/v1/customers/random'

    customer = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(customer["attributes"]["id"]).to eq(customer_1.id).or(eq(customer_2.id))
  end

  describe 'finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @customer = create(:customer, created_at: @created_at, updated_at: @updated_at)
    end

    it 'can find by id' do
      get "/api/v1/customers/find?id=#{@customer.id}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["id"]).to eq(@customer.id)
    end

    it 'can find by first_name' do
      get "/api/v1/customers/find?first_name=#{@customer.first_name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["first_name"]).to eq(@customer.first_name)
    end

    it 'can find by last_name' do
      get "/api/v1/customers/find?last_name=#{@customer.last_name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["last_name"]).to eq(@customer.last_name)
    end

    it 'can find by created_at' do
      get "/api/v1/customers/find?created_at=#{@created_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["id"]).to eq(@customer.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/customers/find?updated_at=#{@updated_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["id"]).to eq(@customer.id)
    end
  end

  describe 'multi-finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @customer_1 = create(:customer, created_at: @created_at, updated_at: @updated_at, last_name: "Smith")
      @customer_2 = create(:customer, updated_at: @updated_at, first_name: "Bob")
      @customer_3 = create(:customer, created_at: @created_at, first_name: "Bob", last_name: "Smith")
    end

    it 'can find_all by id' do
      get "/api/v1/customers/find_all?id=#{@customer_1.id}"

      customer = JSON.parse(response.body)["data"][0]

      expect(response).to be_successful
      expect(customer["attributes"]["id"]).to eq(@customer_1.id)
    end

    it 'can find_all by first_name' do
      get "/api/v1/customers/find_all?first_name=#{@customer_2.first_name}"

      customers = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customers[0]["attributes"]["id"]).to eq(@customer_2.id)
      expect(customers[1]["attributes"]["id"]).to eq(@customer_3.id)
    end

    it 'can find_all by last_name' do
      get "/api/v1/customers/find_all?last_name=#{@customer_1.last_name}"

      customers = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customers[0]["attributes"]["id"]).to eq(@customer_1.id)
      expect(customers[1]["attributes"]["id"]).to eq(@customer_3.id)
    end

    it 'can find by created_at' do
      get "/api/v1/customers/find_all?created_at=#{@created_at}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers["data"][0]["attributes"]["id"]).to eq(@customer_1.id)
      expect(customers["data"][1]["attributes"]["id"]).to eq(@customer_3.id)
      expect(customers["data"].length).to eq(2)
    end

    it 'can find by updated_at' do
      get "/api/v1/customers/find_all?updated_at=#{@created_at}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers["data"][0]["attributes"]["id"]).to eq(@customer_1.id)
      expect(customers["data"][1]["attributes"]["id"]).to eq(@customer_2.id)
      expect(customers["data"].length).to eq(2)
    end
  end

  describe 'relationships' do
    before :each do
      @customer = create(:customer)
      @invoices = create_list(:invoice, 5, customer: @customer)
    end

    it 'can send invoices for a customer' do
      get "/api/v1/customers/#{@customer.id}/invoices"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(5)
      expect(invoices[0]["attributes"]["id"]).to eq(@invoices[0].id)
      expect(invoices[1]["attributes"]["id"]).to eq(@invoices[1].id)
      expect(invoices[2]["attributes"]["id"]).to eq(@invoices[2].id)
      expect(invoices[3]["attributes"]["id"]).to eq(@invoices[3].id)
      expect(invoices[4]["attributes"]["id"]).to eq(@invoices[4].id)
    end

    it 'can send transactions for a customer' do
      @invoices.each do |invoice|
        invoice.transactions << create(:transaction, invoice: invoice)
      end

      get "/api/v1/customers/#{@customer.id}/transactions"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(5)
      expect(transactions[0]["attributes"]["id"]).to eq(@invoices[0].transactions.first.id)
      expect(transactions[1]["attributes"]["id"]).to eq(@invoices[1].transactions.first.id)
      expect(transactions[2]["attributes"]["id"]).to eq(@invoices[2].transactions.first.id)
      expect(transactions[3]["attributes"]["id"]).to eq(@invoices[3].transactions.first.id)
      expect(transactions[4]["attributes"]["id"]).to eq(@invoices[4].transactions.first.id)
    end
  end

  describe 'business intelligence' do
    describe 'single customers' do
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
      it 'it can return the favrite merchant for a customer' do
        get "/api/v1/customers/#{@customer.id}/favorite_merchant"

        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["attributes"]["id"]).to eq(@merchant_1.id)
      end
    end
  end
end
