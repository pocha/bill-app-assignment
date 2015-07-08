## App Structure

Below are the classes `Bill`, `User`, `Item` & `BillItem` 

You should be looking at `amount` function in Bill class

Scroll down for tests.

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
  class BillItem < ActiveRecord::Base
    belongs_to :item
    belongs_to :bill
  end
  class Item < ActiveRecord::Base
    has_many :bill_items
  end
  class User < ActiveRecord::Base
    has_many :bills
  end


## Tests

Below is the rspec test checking the output of the app. Scroll down for the test output

  require 'rails_helper'

  RSpec.describe Bill, type: :model  do 
    before :all do
      @employee = User.create!(name: "employee", is_employee: true, is_affiliate: false, registered_on: Date.today)
      @affiliate = User.create!(name: "affiliate", is_employee: false, is_affiliate: true, registered_on: Date.today)
      @old_user = User.create!(name: "old_customer", is_employee: false, is_affiliate: false, registered_on: 2.years.ago)
      @old_user_but_employee = User.create!(name: "old_customer", is_employee: true, is_affiliate: false, registered_on: 2.years.ago)

      @small_grocery = Item.create!(name: "toffee", cost: 10, is_grocery: true)
      @small_non_grocery = Item.create!(name: "dont know", cost: 10, is_grocery: false)
      @big_grocery = Item.create!(name: "Butter", cost: 200, is_grocery: true)
      @big_non_grocery = Item.create!(name: "Jack Daniel", cost: 200, is_grocery: false)
    end

    before :each do
      @bill = Bill.create
    end

    describe "checking employee discount" do
      before :each do
        @bill.add_user(@employee)
      end
      it "should give discount 30% only on non grocery item (grocery + non grocery < $100)" do
        @bill.add_item(@small_non_grocery,1)
        @bill.add_item(@small_grocery,1)
        expect(@bill.amount).to eq ((@small_non_grocery.cost * 0.7).to_i + @small_grocery.cost)
      end
    end

    describe "checking affiliate discount" do
      before :each do
        @bill.add_user(@affiliate)
      end
      it "should give discount 10% only on non grocery item (grocery + non grocery < $100)" do
      end
    end
    
    describe "user registered earlier to 2 years" do
      before :each do
        @bill.add_user(@old_employee)
      end
      it "should get 5% discount only on non grocery item" 

      it "should give 30% off even if user turned out to be an employee" do
        @bill.add_user(@old_user_but_employee)
        @bill.add_item(@small_non_grocery,1)
        @bill.add_item(@small_grocery,1)
        expect(@bill.amount).to eq ((@small_non_grocery.cost * 0.7).to_i + @small_grocery.cost)
      end

      it "should give 10% if old user is an affiliate" 
    end

    describe "additional discount check beyond $100 billing amount" do
      before :each do
        @bill.add_item(@small_grocery,1)
        @bill.add_item(@small_non_grocery,1)
        @bill.add_item(@big_grocery,1)
        @bill.add_item(@big_non_grocery,1)
        @grocery_total = @small_grocery.cost + @big_grocery.cost
        @non_grocery_total = @small_non_grocery.cost + @big_non_grocery.cost
        
        #debugging
        @bill.bill_items.each do |bill_item|
           puts bill_item.item.name
        end
      end

      it "employee should get 30% off & extra 'beyond $100 discount'" do
        @bill.add_user(@employee)
        amount = (@non_grocery_total * 0.7).to_i + @grocery_total
        amount -= (amount/100).to_i * 5
        expect(@bill.amount).to eq amount
      end

      it "affiliate should get 10% off & extra 'beyond $100 discount'" 

      it "old user should get 5% off & extra 'beyond $100 discount'"
      
    end

  end

## Tests output

  ..*.*toffee
  dont know
  Butter
  Jack Daniel
  .**

  Pending: (Failures listed here are expected and do not affect your suite's status)

    1) Bill user registered earlier to 2 years should get 5% discount only on non grocery item
       # Not yet implemented
       # ./spec/models/bill_spec.rb:43

    2) Bill user registered earlier to 2 years should give 10% if old user is an affiliate
       # Not yet implemented
       # ./spec/models/bill_spec.rb:52

    3) Bill additional discount check beyond $100 billing amount affiliate should get 10% off & extra 'beyond $100 discount'
       # Not yet implemented
       # ./spec/models/bill_spec.rb:77

    4) Bill additional discount check beyond $100 billing amount old user should get 5% off & extra 'beyond $100 discount'
       # Not yet implemented
       # ./spec/models/bill_spec.rb:79

  Finished in 0.15665 seconds (files took 2.02 seconds to load)
  8 examples, 0 failures, 4 pending

