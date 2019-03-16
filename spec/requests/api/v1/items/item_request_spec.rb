require 'rails_helper'

describe 'Items API' do
  it 'sends a list of all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    items = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(items.length).to eq(3)
  end

  it 'can send a single item by id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["attributes"]["id"]).to eq(id)
  end

  it 'can returen a random item' do
    item_1, item_2 = create_list(:item, 2)

    get '/api/v1/items/random'

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["attributes"]["id"]).to eq(item_1.id).or(eq(item_2.id))
  end

  describe 'finder' do
    before :each do
      @created_at = 5.days.ago.strftime("%F %T UTC")
      @updated_at = 5.days.ago.strftime("%F %T UTC")
      @item = create(:item, created_at: @created_at, updated_at: @updated_at)
    end

    it 'it can find by id' do
      get "/api/v1/items/find?id=#{@item.id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end

    it 'it can find by name' do
      get "/api/v1/items/find?name=#{@item.name}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["name"]).to eq(@item.name)
    end

    it 'it can find by description' do
      get "/api/v1/items/find?description=#{@item.description}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["description"]).to eq(@item.description)
    end

    it 'it can find by unit_price' do
      get "/api/v1/items/find?unit_price=#{@item.unit_price / 100.0}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["unit_price"]).to eq((@item.unit_price / 100.0).to_s)
    end

    it 'it can find by merchant_id' do
      get "/api/v1/items/find?merchant_id=#{@item.merchant_id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["merchant_id"]).to eq(@item.merchant_id)
    end

    it 'it can find by created_at' do
      get "/api/v1/items/find?created_at=#{@created_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end

    it 'it can find by updated_at' do
      get "/api/v1/items/find?updated_at=#{@updated_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["id"]).to eq(@item.id)
    end
  end

  describe 'multi-finder' do
    before :each do
      @created_at = 5.days.ago.strftime("%F %T UTC")
      @updated_at = 5.days.ago.strftime("%F %T UTC")
      @item_1 = create(:item, created_at: @created_at, updated_at: @updated_at, description: "Testing")
      @item_2 = create(:item, updated_at: @updated_at, unit_price: 500)
      @item_3 = create(:item, created_at: @created_at)
    end

    it 'it can find by id' do
      get "/api/v1/items/find_all?id=#{@item_1.id}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(1)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
    end

    it 'it can find by name' do
      get "/api/v1/items/find_all?name=#{@item_1.name}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(3)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
      expect(items[1]["attributes"]["id"]).to eq(@item_2.id)
      expect(items[2]["attributes"]["id"]).to eq(@item_3.id)
    end

    it 'it can find by description' do
      get "/api/v1/items/find_all?description=#{@item_1.description}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(1)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
    end

    it 'it can find by unit_price' do
      get "/api/v1/items/find_all?unit_price=#{@item_1.unit_price / 100.0}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(2)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
      expect(items[1]["attributes"]["id"]).to eq(@item_3.id)
    end

    it 'it can find by merchant_id' do
      get "/api/v1/items/find_all?merchant_id=#{@item_1.merchant_id}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(1)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
    end

    it 'it can find by created_at' do
      get "/api/v1/items/find_all?created_at=#{@created_at}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(2)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
      expect(items[1]["attributes"]["id"]).to eq(@item_3.id)
    end

    it 'it can find by updated_at' do
      get "/api/v1/items/find_all?updated_at=#{@updated_at}"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(2)
      expect(items[0]["attributes"]["id"]).to eq(@item_1.id)
      expect(items[1]["attributes"]["id"]).to eq(@item_2.id)
    end
  end

  describe 'relationships' do
    before :each do
      @item = create(:item)
    end

    it 'it can return invoice_items for an item' do
      invoice_item_1, invoice_item_2 = create_list(:invoice_item, 2, item: @item)
      get "/api/v1/items/#{@item.id}/invoice_items"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items.length).to eq(2)
      expect(invoice_items[0]["attributes"]["id"]).to eq(invoice_item_1.id)
      expect(invoice_items[1]["attributes"]["id"]).to eq(invoice_item_2.id)
    end

    it 'it can return merchant for an item' do
      get "/api/v1/items/#{@item.id}/merchant"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["attributes"]["id"]).to eq(@item.merchant_id)
    end
  end

  describe 'business intelligence' do
    describe 'all items' do
      before :each do
        @high_volume_item = create(:item)
        @normal_item = create(:item)
        @expensive_item = create(:item)

        @high_volume_invoice_items = create_list(:invoice_item, 5, item: @high_volume_item, quantity: 100)
        @normal_invoice_items = create_list(:invoice_item, 5, item: @normal_item)
        @expensive_invoice_item = create(:invoice_item, item: @expensive_item, unit_price: 99999)

        @high_volume_invoice_items.each {|invoice_item| invoice_item.invoice.transactions << create(:transaction)}
        @normal_invoice_items.each {|invoice_item| invoice_item.invoice.transactions << create(:transaction)}
        @expensive_invoice_item.invoice.transactions << create(:transaction)
      end

      it 'it can return the top X items by revenue' do
        get "/api/v1/items/most_revenue?quantity=2"

        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["id"]).to eq(@expensive_item.id)
        expect(items[1]["attributes"]["id"]).to eq(@high_volume_item.id)
      end

      it 'it can return the top X items by quantity' do
        get "/api/v1/items/most_items?quantity=2"

        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["id"]).to eq(@high_volume_item.id)
        expect(items[1]["attributes"]["id"]).to eq(@normal_item.id)
      end
    end

    describe 'single items' do
      before :each do
        @customer = create(:customer)
        @merchant = create(:merchant)
        @item = create(:item, merchant: @merchant)
        @two_weeks_ago = 2.weeks.ago.strftime("%F %T UDT")
        @response_time = 2.weeks.ago.strftime("%F")
        @yesterday = 1.day.ago.strftime("%F %T UDT")
        @invoices = create_list(:invoice, 3, created_at: @two_weeks_ago, customer: @customer, merchant: @merchant)
        @invoices.each do |invoice|
          create(:transaction, invoice: invoice, created_at: @two_weeks_ago)
          create(:invoice_item, item: @item, invoice: invoice)
        end
        @invoices = create_list(:invoice, 2, created_at: (2.weeks.ago + 3.hours).strftime("%F %T UTC"), customer: @customer, merchant: @merchant)
        @invoices.each do |invoice|
          create(:transaction, invoice: invoice, created_at: (2.weeks.ago + 3.hours).strftime("%F %T UTC"))
          create(:invoice_item, item: @item, invoice: invoice)
        end
        @invoices = create_list(:invoice, 3, invoice_items: [create(:invoice_item, item: @item)], created_at: @yesterday, customer: @customer, merchant: @merchant)
        @invoices.each do |invoice|
          create(:transaction, invoice: invoice, created_at: @yesterday)
          create(:invoice_item, item: @item, invoice: invoice)
        end
      end

      it 'It can return the date where the item was sold the most' do
        get "/api/v1/items/#{@item.id}/best_day"

        date = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(date["attributes"]["best_day"]).to eq(@response_time)
      end
    end
  end
end
