class Discount < ApplicationRecord
  belongs_to :item
  validates :rate, presence: true, numericality: {
    greater_than_or_equal_to: 0}
  validates :quantity, presence: true, numericality: {
    greater_than_or_equal_to: 0}

end
