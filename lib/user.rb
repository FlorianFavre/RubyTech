require_relative 'market'
require_relative 'order'
require 'bigdecimal'
require 'bigdecimal/util'

class User
  attr_accessor :user_id, :name, :email, :btc_balance, :eur_balance, :orders

  def initialize(user_id, name, email, eur_balance, btc_balance )
    @user_id = user_id
    @name = name
    @email = email
    @btc_balance = btc_balance
    @eur_balance = eur_balance
    @orders = []
  end

  #decreased balance of euro
  def decrease_eur(amount)
    @eur_balance -= amount
  end

  #increased balance of euro
  def increase_eur(amount)
    @eur_balance += amount
  end

  #decreased balance of btc
  def decrease_btc(amount)
    @btc_balance -= amount
  end

  #increased balance of btc
  def increase_btc(amount)
    @btc_balance += amount
  end

  # add order to the user's order list
  def add_order(order)
    if order.side == 1
      # Si l'utilisateur achète, vérifiez s'il a suffisamment d'euros
      if @eur_balance < order.price * order.amount
        return false
      end
    else
      # Si l'utilisateur vend, vérifiez s'il a suffisamment de BTC
      return false if @btc_balance < order.amount
    end
    @orders << order
    return true
  end
  

  #change the state of the order to closed
  def close_order(order_id)
    @orders.each do |order|
      if order.order_id == order_id
        order.state = 2
        #puts "Order number #{order_id} closed for user #{user_id}\n"
      end
    end
  end  

end