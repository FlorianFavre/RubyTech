require_relative 'market'
require_relative 'user'
require 'bigdecimal'
require 'bigdecimal/util'

class Order
  attr_accessor :order_id, :side, :price, :amount, :user_id, :state, :market

  def initialize(order_id, side, price, amount, user_id, market)
    @order_id = order_id
    @side = side
    @price = price
    @amount = amount
    @user_id = user_id
    @state = 1
    @market = market
  end

  #change the state of the order to closed
  def close_order
    @state = 2
    puts "Order number #{@order_id} closed \n"
  end

end