
class Market
  attr_accessor :bids, :base, :quote, :asks

  def initialize
    @base = "BTC"
    @quote = "EUR"
    @bids = []
    @asks = []
    @orders = []
  end

  def submit(order)
    @orders << order
    if order[3] == 1
      @bids.append([order[2].to_f, order[1].truncate(8)])
    else
      @asks.append([order[2].to_f, order[1].truncate(8)])
    end
    return "Order number #{order[0]} submitted"
  end

  def market_price
    #make an average between the best bid and the best ask
    return (@bids[0][0] + @asks[0][0]) / 2

  end

  def market_depth
    return "bids: #{@bids} \n
    base: #{@base} \n
    quote: #{@quote} \n
    asks: #{@asks}"
  end

  def cancel_order(id)
    side = @orders[id]
    if side == 1
      @bids.delete_at(id)
    else
      @asks.delete_at(id)
    end
    puts "Order number #{id} canceled"
    puts "bids: #{@bids} \n
    base: #{@base} \n
    quote: #{@quote} \n
    asks: #{@asks}"
  end
end
