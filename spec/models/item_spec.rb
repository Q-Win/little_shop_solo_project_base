require 'rails_helper'

RSpec.describe Item, type: :model do

  before(:each) do
    @merch = User.create(email: 'bob', password: 'bob', name: 'bob', address: "bob",
      city: 'Denver', state: 'CO', zip: 80203, role: 1)
    @item_1 = @merch.items.create(name: "taco", description: "yum", price: 100,
      inventory: 1000)
    @item_2 = @merch.items.create(name: "burrito", description: "yum", price: 200,
      inventory: 1000)
    @discount_1 = @item_1.discounts.create(rate: 70, quantity: 100)
    @discount_2 = @item_1.discounts.create(rate: 50, quantity: 5)
    @discount_3 = @item_1.discounts.create(rate: 10, quantity: 2)
  end

  describe 'Relationships' do
    it { should belong_to(:user) }
    it { should have_many(:discounts) }
    it { should have_many(:order_items) }
    it { should have_many(:orders).through(:order_items) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :inventory }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe 'Class Methods' do
    it '.popular_items(quantity)' do
      user = create(:user)
      merchants = create_list(:merchant, 2)
      item_1 = create(:item, user: merchants[0])
      item_2 = create(:item, user: merchants[0])
      item_3 = create(:item, user: merchants[1])
      item_4 = create(:item, user: merchants[1])
      orders = create_list(:completed_order, 2, user: user)
      create(:fulfilled_order_item, quantity: 10, item: item_1, order: orders[0])
      create(:fulfilled_order_item, quantity: 20, item: item_2, order: orders[0])
      create(:fulfilled_order_item, quantity: 40, item: item_3, order: orders[1])
      create(:fulfilled_order_item, quantity: 30, item: item_4, order: orders[1])

      expect(Item.popular_items(3)).to eq([item_3, item_4, item_2])
    end
  end

  describe 'Instance Methods' do
    it 'can ignore discounts when there isnt one' do
      item_2_price = @item_2.apply_discount(100)

      expect(item_2_price).to eq(200)
    end

    it 'can apply discount' do
      item_1_price = @item_1.apply_discount(10)

      expect(item_1_price).to eq(50.0)
    end

  end
end
