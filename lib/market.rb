require 'bigdecimal'
require 'bigdecimal/util'

class Market
  attr_accessor :bids, :base, :quote, :asks

  def initialize
    @base = "BTC"
    @quote = "EUR"
    @bids = []
    @asks = []
  end

  def submit(order)
    if order["side"] == 1
      @bids.append([order["order_id"], order["price"], order["amount"]])
    elsif order["side"] == 2
      @asks.append([order["order_id"], order["price"], order["amount"]])
    end
    return "\n Order number #{order["order_id"]} submitted \n"
  end

  def market_price
    if(@bids.empty? || @asks.empty?)
      return "\n No market price \n"
    else
      m_price_bids = 0
      m_price_asks = 0
      @bids.each do |bid|
        if bid[1] > m_price_bids
          m_price_bids = bid[1]
        end
      end
      @asks.each do |ask|
        if ask[1] < m_price_asks
          m_price_asks = ask[1]
        end
      end
      calc = (m_price_bids + m_price_asks) / 2      
      return calc.round(2)

    end
  end

  def market_depth
    if(@bids.empty? || @asks.empty?)
      return "\n No market price \n"
    else
      depth =  "\n {\"bids\"=> \n["
      #parcours les bids et transforme la colonne price en float, la colonne amount en décimale avec huit chiffres après la virgule
      @bids.each do |bid|
        depth += "[\"#{bid[1]}\", \"#{bid[2]}\"],\n"
      end
      depth.delete_suffix!(",\n")
      depth += "]\n \"base\"=>\"#{@base}\", \n"
      depth += "\"quote\"=>\"#{@quote}\", \n"
      #parcours les asks et transforme la colonne price en float, la colonne amount en décimale avec huit chiffres après la virgule
      depth += "\"asks\"=> \n["
      @asks.each do |ask|
        depth += "[\"#{ask[1]}\", \"#{ask[2]}\"],\n"
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
