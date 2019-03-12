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

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(id)
  end
end
