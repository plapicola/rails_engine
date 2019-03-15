require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do

  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'class methods' do
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

    describe 'top_by_items(limit)' do
      it 'returns a list of the top items by quantity sold' do
        expect(Item.top_by_items(2)).to eq([@high_volume_item, @normal_item])
      end
    end

    describe 'top_by_revenue(limit)' do
      it 'returns a list of the top items by revenue' do
        expect(Item.top_by_revenue(2)).to eq([@expensive_item, @high_volume_item])
      end
    end
  end

  describe 'instance methods' do
    describe 'best_day' do
      before :each do
        @customer = create(:customer)
        @merchant = create(:merchant)
        @item = create(:item, merchant: @merchant)
        @two_weeks_ago = 2.weeks.ago.strftime("%F %T UTC")
        @yesterday = 1.day.ago.strftime("%F %T UTC")
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

      it 'returns the day where the item was sold the most' do
        expect(@item.best_day.best_day.strftime("%F %T UTC")).to eq(@two_weeks_ago)
      end
    end
  end
end
