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
