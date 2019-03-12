require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants/'

    expect(response).to be_successful
    expect(JSON.parse(response.body).count).to eq(3)
  end

  it 'can get a merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it 'can find a merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/find?id=#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it 'can find a merchant by its name' do
    name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(name)
  end

  it 'can find a merchant by its created_at time' do
    time_parameter = "2012-03-27T14:54:05.000Z"
    created_at = "2012-03-27 14:54:05 UTC"
    create(:merchant, created_at: created_at)

    get "/api/v1/merchants/find?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["created_at"]).to eq(time_parameter)
  end

  it 'can find a merchant by its updated_at time' do
    time_parameter = "2012-03-27T14:54:05.000Z"
    updated_at = "2012-03-27 14:54:05 UTC"
    create(:merchant, updated_at: updated_at)

    get "/api/v1/merchants/find?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["updated_at"]).to eq(time_parameter)
  end
end
