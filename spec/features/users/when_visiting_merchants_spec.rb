require 'rails_helper'
require 'feature_helper'

RSpec.describe 'When visiting merchants' do
  include FeatureHelper
  before(:each) do
    @admin = create(:admin)

  end

  it 'can see merchant stats' do
    user = create(:user)
    user_2 = create(:user, city: @admin.city, state: @admin.state)
    merchant_1, merchant_2, merchant_3, merchant_4 = create_list(:merchant, 4)
    i_ship_to_admin = User.create(name: 'I ship to Admin! ',address: '123', city: "denver", state: "CO",zip: 80203, email: "bob",password: 'bob', role: 1)
    i_fulfill_slow = User.create(name: 'I fullfill slow! ',address: '123', city: "denver", state: "CO",zip: 80203, email: "slowpoke",password: 'bob', role: 1)
    item_1, item_2 = create_list(:item, 2, user: merchant_4)
    item_3, item_4 = create_list(:item, 2, user: merchant_2)
    item_5, item_6  = create_list(:item, 2, user: merchant_3)
    item_7, item_8  = create_list(:item, 2, user: i_ship_to_admin)
    item_9, item_10  = create_list(:item, 2, user: i_fulfill_slow)

    order_1 = create(:order, user: user, status: 'completed')
    create(:order_item, order: order_1, item: item_1, quantity: 100, fulfilled: true)

    order_2 = create(:order, user: user, status: 'completed')
    create(:order_item, order: order_2, item: item_3, fulfilled: true)

    order_3 = create(:order, user: user, status: 'completed')
    create(:order_item, order: order_3, item: item_3,quantity: 1000, fulfilled: true)
    order_3.update(created_at: 101.days.ago, updated_at: 100.days.ago)

    order_3 = create(:order, user: user_2, status: 'completed')
    create(:order_item, order: order_3, item: item_5,quantity: 1000, fulfilled: true)
    order_3.update(created_at: 101.days.ago, updated_at: 100.days.ago)

    order_4 = create(:order, user: user_2, status: 'completed')
    create(:order_item, order: order_4, item: item_5,quantity: 1, fulfilled: true)

    order_5 = create(:order, user: user_2, status: 'completed')
    create(:order_item, order: order_5, item: item_7,quantity: 1, fulfilled: true)

    order_6 = create(:order, user: user_2, status: 'completed')
    create(:order_item, order: order_6, item: item_9,quantity: 1, fulfilled: true)
    order_6.update(created_at: 101.days.ago, updated_at: 70.days.ago)

    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'
    visit merchants_path

    # save_and_open_page

    expect(page).to have_content("Merch who sell the most items")
    expect(page).to have_content("Merchant 4 Merchant 2 I ship to Admin! Merchant 3")

    expect(page).to have_content("Merch who fullfill the most orders")
    expect(page).to have_content("I ship to Admin! Merchant 2 Merchant 3 Merchant 4")

    expect(page).to have_content("Merch who fullfill orders in my state the fastest")
    expect(page).to have_content("Merchant 3 I ship to Admin! I fullfill slow!")

    expect(page).to have_content("Merch who fullfill orders in my city the fastest")
    expect(page).to have_content("Merchant 3 I ship to Admin! I fullfill slow!")
  end

end
