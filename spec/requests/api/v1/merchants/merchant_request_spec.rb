require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants/'

    expect(response).to be_successful
    expect(JSON.parse(response.body)['data'].count).to eq(3)
  end

  it 'can get a merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(id)
  end

  describe 'finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @merchant = create(:merchant, created_at: @created_at, updated_at: @updated_at)
    end

    it 'can find a merchant by its id' do
      id = @merchant.id

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(id)
    end

    it 'can find a merchant by its name' do
      name = @merchant.name

      get "/api/v1/merchants/find?name=#{name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["name"]).to eq(name)
    end

    it 'can find a merchant by its created_at time' do
      get "/api/v1/merchants/find?created_at=#{@created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(@merchant.id)
    end

    it 'can find a merchant by its updated_at time' do
      get "/api/v1/merchants/find?updated_at=#{@updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(@merchant.id)
    end
  end

  describe 'multi-finders' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @merchant_1 = create(:merchant, name: "Bob", created_at: @created_at, updated_at: @updated_at)
      @merchant_2 = create(:merchant, name: "Bob", updated_at: @updated_at)
      @merchant_3 = create(:merchant, name: "Jim", created_at: @created_at, updated_at: @updated_at)
    end

    it 'can find all merchants by id' do
      get "/api/v1/merchants/find_all?id=#{@merchant_1.id}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants["data"][0]["attributes"]["id"]).to eq(@merchant_1.id)
      expect(merchants.length).to eq(1)
    end

    it 'can find all merchants by name' do
      get "/api/v1/merchants/find_all?name=#{@merchant_1.name}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants["data"][0]["attributes"]["name"]).to eq(@merchant_1.name)
      expect(merchants["data"][1]["attributes"]["name"]).to eq(@merchant_2.name)
      expect(merchants["data"].length).to eq(2)
    end

    it 'can find all merchants by created_at' do
      get "/api/v1/merchants/find_all?created_at=#{@created_at}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants["data"][0]["attributes"]["id"]).to eq(@merchant_1.id)
      expect(merchants["data"][1]["attributes"]["id"]).to eq(@merchant_3.id)
      expect(merchants["data"].length).to eq(2)
    end

    it 'can find all merchants by updated_at' do
      get "/api/v1/merchants/find_all?updated_at=#{@updated_at}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants["data"][0]["attributes"]["id"]).to eq(@merchant_1.id)
      expect(merchants["data"][1]["attributes"]["id"]).to eq(@merchant_2.id)
      expect(merchants["data"][2]["attributes"]["id"]).to eq(@merchant_3.id)
      expect(merchants["data"].length).to eq(3)
    end
  end

  describe 'relationships' do
    before :each do
      @merchant = create(:merchant)
    end

    it "Returns items for merchant" do
      item_1, item_2, item_3 = create_list(:item, 3, merchant: @merchant)

      get "/api/v1/merchants/#{@merchant.id}/items"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items["data"].length).to eq(3)
      expect(items["data"][0]["id"]).to eq(item_1.id)
      expect(items["data"][1]["id"]).to eq(item_2.id)
      expect(items["data"][2]["id"]).to eq(item_3.id)
    end

    it "Returns invoices for a merchant" do
      invoice_1, invoice_2, invoice_3 = create_list(:invoice, 3, merchant: @merchant)

      get "/api/v1/merchants/#{@merchant.id}/invoices"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices["data"].length).to eq(3)
      expect(invoices["data"][0]["id"]).to eq(invoice_1.id)
      expect(invoices["data"][1]["id"]).to eq(invoice_2.id)
      expect(invoices["data"][2]["id"]).to eq(invoice_3.id)
    end
  end
end
