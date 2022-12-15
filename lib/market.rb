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

  def submit(order, users, orders)
    if order.side == 1
      @bids << order
    elsif order.side == 2
      @asks << order
    end
    puts "Order number #{order.order_id} submitted \n"

    match(order, users, orders)
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
  
          # Remove the matched orders from the market
          @bids.shift
          @asks.shift

          puts "*** MATCHED ***"
          puts order.user_id
          puts "Order number #{bid.order_id} matched with order number #{ask.order_id}"
          puts "Amount: #{bid.amount.round(8).to_s("F")}"
          puts "Price: #{bid.price.round(8).to_s("F")}"
          puts "Side: #{bid.side}"
          puts "Timestamp: #{Time.now}"
          puts "****************"
  
          #parcours users pour changer les balances
          users.each do |user|
            puts user.user_id
            if user.user_id == bid.user_id
              user.btc_balance = user.btc_balance - bid.amount
              user.eur_balance = user.eur_balance + bid.amount * bid.price
            end
            if user.user_id == ask.user_id
              user.btc_balance = user.btc_balance + ask.amount
              user.eur_balance = user.eur_balance - ask.amount * ask.price
            end
          end

          #affiche tous les users et leurs balances
          users.each do |user|
            puts "User #{user.user_id} has #{user.btc_balance.round(8).to_s("F")} BTC and #{user.eur_balance.round(2).to_s("F")} EUR"
          end
  
          # Save the match
          @matches << {
            "order_id" => bid.order_id,
            "amount" => bid.amount,
            "price" => bid.price,
            "side" => bid.side,
            "timestamp" => Time.now
          }
        end
      end
    end 
end
