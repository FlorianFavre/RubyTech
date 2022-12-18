require_relative 'user'
require_relative 'order'
require 'bigdecimal'
require 'bigdecimal/util'

class Market
  attr_accessor :bids, :base, :quote, :asks

  def initialize
    @base = ""
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

  
end
