class Discount < ApplicationRecord
    validates_presence_of :discount, :threshold

  belongs_to :merchant
end