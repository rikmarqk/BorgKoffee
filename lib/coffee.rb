class Coffee < ActiveRecord::Base
    has_many :coffee_receipts
    has_many :receipts, through: :coffee_receipts
end