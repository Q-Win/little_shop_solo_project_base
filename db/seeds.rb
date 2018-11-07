require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user, state: "CO", city: "denver")
pat = create(:user, name:'pat', email: "pat", password: 'pat', state: "MA", city: "foco")
merchant_1 = create(:merchant)

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

adquinn = User.create(name: 'quinn',address: '123', city: "denver", state: "CO",zip: 80203, email: "quinn",password: 'quinn', role: 2)
bob = User.create(name: 'bob',address: '123', city: "denver", state: "CO",zip: 80203, email: "bob",password: 'bob', role: 1)
steve = User.create(name: 'steve',address: '123', city: "denver", state: "CO",zip: 80203, email: "steve",password: 'steve', role: 1)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
item_5 = create(:item, user: bob)
create_list(:item, 10, user: merchant_1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_5, price: 5, quantity: 7)
create(:fulfilled_order_item, order: order, item: item_3, price: 1, quantity: 1000)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)


order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)

order = create(:completed_order, user: pat)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
