class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :discounts

  validates_presence_of :name, :description
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def self.popular_items(quantity)
    select('items.*, sum(order_items.quantity) as total_ordered')
      .joins(:orders)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('items.id, order_items.id')
      .order('total_ordered desc')
      .limit(quantity)
  end

  def check_for_discount
    discounts.count >= 1
  end

  def apply_discount(amount_purchased)
    if check_for_discount
      if discounts.where("quantity <= #{amount_purchased}").count > 0
        discount = discounts.where("quantity <= #{amount_purchased}").order(:quantity).reverse
        discount_rate = 1 - discount.first.rate/100.0
        final_price = price * discount_rate
      else
        self.price
      end
    else
      self.price
    end
  end
end
