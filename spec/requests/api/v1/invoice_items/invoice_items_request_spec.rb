require 'rails_helper'

describe 'Invoice Items API' do
  it 'can send all invoice items' do
    invoice_item_1, invoice_item_2, invoice_item_3 = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/"

    invoice_items = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(response[0]["attributes"]["id"]).to eq(invoice_item_1.id)
    expect(response[1]["attributes"]["id"]).to eq(invoice_item_2.id)
    expect(response[2]["attributes"]["id"]).to eq(invoice_item_3.id)
  end

  it 'can send a single invoice item' do
    invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/#{invoice_item.id}"

    found_invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(found_invoice_item["attributes"]["id"]).to eq(invoice_item.id)
  end

  it 'can send a random invoice item' do
    invoice_item_1, invoice_item_2 = create_list(:invoice_item, 2)

    get "/api/v1/invoice_items/random"

    found_invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(found_invoice_item["attrbutes"]["id"]).to eq(invoice_item_1.id).or(eq(invoice_item_2.id))
  end

  describe 'finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @invoice_item = create(:invoice_item, created_at: @created_at, updated_at: @updated_at)
    end
    it 'can find by id' do
      get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["id"]).to eq(@invoice_item.id)
    end

    it 'can find by item_id' do
      get "/api/v1/invoice_items/find?item_id=#{@invoice_item.item_id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["item_id"]).to eq(@invoice_item.item_id)
    end

    it 'can find by invoice_id' do
      get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item.invoice_id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["invoice_id"]).to eq(@invoice_item.invoice_id)
    end

    it 'can find by quantity' do
      get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["quantity"]).to eq(@invoice_item.quantity)
    end

    it 'can find by unit_price' do
      get "/api/v1/invoice_items/find?unit_price=#{@invoice_item.unit_price}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["unit_price"]).to eq(@invoice_item.unit_price)
    end

    it 'can find by created_at' do
      get "/api/v1/invoice_items/find?created_at=#{@created_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["id"]).to eq(@invoice_item.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoice_items/find?updated_at=#{@updated_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["id"]).to eq(@invoice_item.id)
    end
  end

  describe 'multi-finder' do
    before :each do
      @created_at = "2012-03-27 14:54:05 UTC"
      @updated_at = "2012-03-27 14:54:05 UTC"
      @item = create(:item)
      @invoice = create(:invoice)
      @invoice_item_1 = create(:invoice_item, created_at: @created_at, updated_at: @updated_at, item: @item)
      @invoice_item_2 = create(:invoice_item, updated_at: @updated_at, invoice: @invoice, quantity: 400)
      @invoice_item_3 = create(:invoice_item, created_at: @created_at, item: @item, invoice: @invoice)
    end

    it 'can find by id' do
      get "/api/v1/invoice_items/find_all?id=#{@invoice_item_1.id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_1.id)
    end

    it 'can find by item_id' do
      get "/api/v1/invoice_items/find_all?item_id=#{@item.id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["attrbutes"]["id"]).to eq(@invoice_item_3.id)
    end

    it 'can find by invoice_id' do
      get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice.id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_2.id)
      expect(invoice_items[1]["attrbutes"]["id"]).to eq(@invoice_item_3.id)
    end

    it 'can find by quantity' do
      get "/api/v1/invoice_items/find_all?quantity=#{@invoice_item_2.quantity}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_2.id)
    end

    it 'can find by unit_price' do
      get "/api/v1/invoice_items/find_all?unit_price=#{(@invoice_item_1.unit_price / 100.0)}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["attrbutes"]["id"]).to eq(@invoice_item_2.id)
      expect(invoice_items[2]["attrbutes"]["id"]).to eq(@invoice_item_3.id)
    end

    it 'can find by created_at' do
      get "/api/v1/invoice_items/find_all?created_at=#{@created_at}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["attrbutes"]["id"]).to eq(@invoice_item_3.id)
    end

    it 'can find by updated_at' do
      get "/api/v1/invoice_items/find_all?updated_at=#{@updated_at}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items[0]["attrbutes"]["id"]).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["attrbutes"]["id"]).to eq(@invoice_item_2.id)
    end
  end

  describe 'relationships' do
    before :each do
      @invoice = create(:invoice)
      @item = create(:item)
      @invoice_item = create(:invoice_item, invoice: @invoice, item: @item)
    end

    it 'can return the item' do
      get "/api/v1/invoice_items/#{@invoice_item.id}/item"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end

    it 'can return the invoice' do
      get "/api/v1/invoice_items/#{@invoice_item.id}/item"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["attrbites"]["id"]).to eq(@invoice.id)
    end
  end
end
