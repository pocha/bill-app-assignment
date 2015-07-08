class Bill < ActiveRecord::Base
  has_many :bill_items
  has_many :items, through: :bill_items
  belongs_to :user

  def add_item(item, quantity)
    BillItem.create(bill_id: self.id, item_id: item.id, quantity: quantity)
  end

  def add_user(user)
    self.user = user
    self.save
  end

  def amount
    percent_discount = 0
    user = self.user
    bill_items = self.bill_items

    if user.is_employee
      percent_discount = 30
    elsif user.is_affiliate 
      percent_discount = 10
    elsif Time.now.year - user.registed_on.year >= 2
      percent_discount = 5
    end
    
    amount = 0
    amount_for_percent_discount = 0
    bill_items.each do |bill_item|
      net_cost = bill_item.item.cost * bill_item.quantity
      amount += net_cost
      amount_for_percent_discount += net_cost if !bill_item.item.is_grocery
    end

    #puts "total amount #{amount}"
    #puts "total amount for discount #{amount_for_percent_discount}"
    
    amount -=  ((amount_for_percent_discount * percent_discount)/100).to_i
    extra_discount = (amount/100).to_i * 5
    amount -= extra_discount
    amount
  end
end
