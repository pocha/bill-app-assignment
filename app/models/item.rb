class Item < ActiveRecord::Base
  has_many :bill_items
end
