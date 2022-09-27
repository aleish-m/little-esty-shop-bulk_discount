class Discount < ApplicationRecord
  validates_presence_of :discount, :threshold
  validates :discount, numericality: { less_than_or_equal_to: 1}
  validates_numericality_of :threshold, message: "is not a number"
  belongs_to :merchant
end