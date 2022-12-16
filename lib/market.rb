require_relative 'user'
require_relative 'order'
require 'bigdecimal'
require 'bigdecimal/util'

class Market
  attr_accessor :bids, :base, :quote, :asks

  def initialize
    @base = "BTC"
    @quote = "EUR"
    @bids = []
    @asks = []    
    @matches = []
  end

  def submit(order)
    if order.side == 1
      @bids << order
    elsif order.side == 2
      @asks << order
    end
    puts "Order number #{order.order_id} submitted \n"    
  end

  def market_price
    if(@bids.empty? || @asks.empty?)
      return "\n No market price \n"
    else
      m_price_bids = BigDecimal(0)
      m_price_asks = BigDecimal(0)
      calc = BigDecimal(0)
      @bids.each do |bid|
        if bid.price > m_price_bids
          m_price_bids = bid.price
        end
      end
      @asks.each do |ask|
        if ask.price. < m_price_asks
          m_price_asks = ask.price
        end
      end
      calc = (m_price_bids + m_price_asks) / 2
      puts calc.round(2).to_s("F")
    end
  end

  def market_depth    
    if(@bids.empty? || @asks.empty?)
      return "\n No market price \n"
    else
      depth =  "\n {\"bids\"=> \n["
      #iterate through the bids and transform the price column into a float, the amount column into a decimal with eight decimal places
      @bids.each do |bid|
        depth += "[\"#{bid.price.round(2).to_s("F")}\", \"#{bid.amount.round(8).to_s("F")}\"],\n"
      end
      depth.delete_suffix!(",\n")
      depth += "]\n \"base\"=>\"#{@base}\", \n"
      depth += "\"quote\"=>\"#{@quote}\", \n"
      #iterates through the asks and transforms the price column into a float, the amount column into a decimal with eight decimal places
      depth += "\"asks\"=> \n["
      @asks.each do |ask|
        depth += "[\"#{ask.price.round(2).to_s("F")}\", \"#{ask.amount.round(8).to_s("F")}\"],\n"
      end
      depth.delete_suffix!(",\n")
      puts depth += "]}\n"
    end
  end

  def cancel_order(id)

    if(@bids.empty? || @asks.empty?)
      return "\n No order to cancel \n"
    else
      side = 0
      @bids.each do |bid|
        if(bid[0].to_i == id)
          side = 1
          @bids.delete_at(id-1)
        end
      end
      if side == 0
        @asks.each do |ask|
          if(ask[0].to_i == id)
            @asks.delete_at(id-1)
          end
        end
      end
      puts "Order number #{id} canceled"
      puts "bids: #{@bids} \n
      base: #{@base} \n
      quote: #{@quote} \n
      asks: #{@asks}"
    end
  end

  def match(order, users, orders)
    # Compare the first bid and ask to see if they match
    if @bids.length > 0 && @asks.length > 0
      bid = @bids[0]
      ask = @asks[0]

      # Check if the orders match
      if bid.side != ask.side &&
          bid.price == ask.price &&
          bid.amount == ask.amount

          order.close_order

        # Remove the matched orders from the market
        @bids.shift
        @asks.shift

        puts "*** MATCHED ***"
        puts "Order number #{bid.order_id} matched with order number #{ask.order_id}"
        puts "****************"

        puts bid.amount.round(8).to_s("F")

        #calculate fees
        bid_fee = bid.price * 0.0025

        #change balance of users
        users.each do |user|
          puts user.user_id
          if user.user_id == ask.user_id
            if user.btc_balance - order.amount >= 0
              user.btc_balance = user.btc_balance - order.amount
              user.eur_balance = user.eur_balance + bid.amount * bid.price - bid_fee / 2
              user.close_order(ask.order_id)
            else
              puts "Insufficient btc_balance \n"
              puts user.btc_balance.round(8).to_s("F")
              puts order.amount.round(8).to_s("F")
              return false
            end
          end
          if user.user_id == bid.user_id
            if user.eur_balance - ask.amount * ask.price >= 0
              user.btc_balance = user.btc_balance + order.amount
              user.eur_balance = user.eur_balance - ask.amount * ask.price  - bid_fee / 2
              user.close_order(bid.order_id)
            else
              puts "Insufficient funds \n"
              puts user.eur_balance.round(8).to_s("F")
              puts (ask.amount * ask.price).round(8).to_s("F")
              return false
            end
          end
        end

        users.first.eur_balance = users.first.eur_balance + bid_fee
        puts "Fee user have:"
        puts users.first.eur_balance.round(8).to_s("F")

        #see users and balances
        users.each do |user|
          puts "User #{user.user_id} has #{user.btc_balance.to_s("F")} BTC and #{user.eur_balance.to_s("F")} EUR"
        end

        #delete this order from orders if bid and ask match
        orders.delete_if { order.order_id == bid.order_id || order.order_id == ask.order_id}   

        #see orders
        orders.each do |order|
          puts "Order number #{order.order_id} has #{order.amount.to_s("F")} BTC and #{order.price.to_s("F")} EUR"
        end

        #save the match
        @matches << {
          "order_id" => bid.order_id,
          "amount" => bid.amount,
          "price" => bid.price,
          "side" => bid.side,
          "timestamp" => Time.now
        }
      end
    puts "no match"
    end
  end 
end
