require_relative 'market'
require_relative 'order'
require 'bigdecimal'
require 'bigdecimal/util'

class User
  attr_accessor :user_id, :name, :email, :btc_currency_balance, :quote_currency_balance, :eth_currency_balance, :orders

  def initialize(user_id, name, email, quote_currency_balance, btc_currency_balance, eth_currency_balance)
    @user_id = user_id
    @name = name
    @email = email
    @btc_currency_balance = btc_currency_balance
    @eth_currency_balance = eth_currency_balance
    @quote_currency_balance = quote_currency_balance
    @orders = []
  end

  # add order to the user's order list
  def add_order(order)
    if order.side == 1
      # Si l'utilisateur achète, vérifiez s'il a suffisamment d'euros
      if @quote_currency_balance < order.price * order.amount
        return false
      end
    else
      if(order.market == "Bitcoin")
        # Si l'utilisateur vend, vérifiez s'il a suffisamment de BTC
        return false if @btc_currency_balance < order.amount
      elsif (order.market == "Ethereum")
        # Si l'utilisateur vend, vérifiez s'il a suffisamment de ETH
        return false if @eth_currency_balance < order.amount
      end
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

  #view all balances
  def view_balances
    puts "User #{@user_id} has #{@quote_currency_balance.to_s("F")} euros, #{@btc_currency_balance.to_s("F")} BTC and #{@eth_currency_balance.to_s("F")} ETH"
  end

end