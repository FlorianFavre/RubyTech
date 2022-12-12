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
      @bids.append([order["price"], order["amount"]])
    elsif order["side"] == 2
      @asks.append([order["price"], order["amount"]])
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
        if bid[0] > m_price_bids
          m_price_bids = bid[0]
        end
      end
      @asks.each do |ask|
        if ask[0] < m_price_asks
          m_price_asks = ask[0]
        end
      end
      calc = (m_price_bids + m_price_asks) / 2      
      return sprintf( "%.02f", calc)

    end
  end

  def market_depth
    if(@bids.empty? || @asks.empty?)
      return "\n No market price \n"
    else
      depth =  "\n {\"bids\"=> \n["
      #parcours les bids et transforme la colonne price en float, la colonne amount en décimale avec huit chiffres après la virgule
      @bids.each do |bid|
        depth += "[\"#{sprintf( "%.02f", bid[0])}\", \"#{sprintf( "%.08f", bid[1])}\"],\n"
      end
      depth -= ",\n"
      depth += "]\n base=>\"#{@base}\", \n"
      depth += "quote=>\"#{@quote}\", \n"
      #parcours les asks et transforme la colonne price en float, la colonne amount en décimale avec huit chiffres après la virgule
      depth += "\"asks\"=> \n["
      @asks.each do |ask|
        depth += "[\"#{sprintf( "%.02f", ask[0])}\", \"#{sprintf( "%.08f", ask[1])}\"],\n"
      end
      depth -= ",\n"
      puts depth += "]}\n"
    end
  end

  def cancel_order(id)

    if(@bids.empty? || @asks.empty?)
      return "\n No order to cancel \n"
    else
      side = 0
      @bids.each do |bid|
        if(bid[id] != nil)
          side = 1
          @bids.delete_at(bid)
        end
      end
      if side == 0
        @asks.each do |ask|
          if(ask[id] != nil)
            @asks.delete_at(ask)
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
