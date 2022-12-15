require_relative 'market'
require_relative 'user'
class Order
  attr_accessor :order_id, :side, :price, :amount, :user_id, :state

  def initialize(order_id, side, price, amount, user_id)
    @order_id = order_id
    @side = side
    @price = price
    @amount = amount
    @user_id = user_id
    @state = 1
  end



end