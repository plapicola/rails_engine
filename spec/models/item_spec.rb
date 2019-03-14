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
end
