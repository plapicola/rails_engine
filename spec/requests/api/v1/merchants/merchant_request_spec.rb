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
      @time_parameter = "2012-03-27T14:54:05.000Z"
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
      expect(merchant["data"]["attributes"]["created_at"]).to eq(@time_parameter)
    end

    it 'can find a merchant by its updated_at time' do
      get "/api/v1/merchants/find?updated_at=#{@updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["updated_at"]).to eq(@time_parameter)
    end
  end

  describe 'multi-finders' do
    before :each do
      @time_parameter = "2012-03-27T14:54:05.000Z"
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
      expect(merchants["data"][0]["attributes"]["created_at"]).to eq(@time_parameter)
      expect(merchants["data"][1]["attributes"]["created_at"]).to eq(@time_parameter)
      expect(merchants["data"].length).to eq(2)
    end

    it 'can find all merchants by updated_at' do
      get "/api/v1/merchants/find_all?updated_at=#{@updated_at}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants["data"][0]["attributes"]["updated_at"]).to eq(@time_parameter)
      expect(merchants["data"][1]["attributes"]["updated_at"]).to eq(@time_parameter)
      expect(merchants["data"][2]["attributes"]["updated_at"]).to eq(@time_parameter)
      expect(merchants["data"].length).to eq(3)
    end
  end

  describe 'relationships' do
    pending "Returns items for merchant"
  end
end
