class Market_Bitcoin < Market

  def initialize
    @base = "BTC"
    @quote = "EUR"
    @bids = []
    @asks = []    
    @matches = []
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

        #calculate fees
        bid_fee = bid.price * 0.0025

        #change balance of users
        users.each do |user|
          puts user.user_id
          if user.user_id == ask.user_id
            if user.btc_currency_balance - order.amount >= 0
              user.btc_currency_balance = user.btc_currency_balance - order.amount
              user.quote_currency_balance = user.quote_currency_balance + bid.amount * bid.price - bid_fee / 2
              user.close_order(ask.order_id)
            else
              puts "Insufficient btc_currency_balance \n"
              puts user.btc_currency_balance.round(8).to_s("F")
              puts order.amount.round(8).to_s("F")
              return false
            end
          end
          if user.user_id == bid.user_id
            if user.quote_currency_balance - ask.amount * ask.price >= 0
              user.btc_currency_balance = user.btc_currency_balance + order.amount
              user.quote_currency_balance = user.quote_currency_balance - ask.amount * ask.price  - bid_fee / 2
              user.close_order(bid.order_id)
            else
              puts "Insufficient funds \n"
              puts user.quote_currency_balance.round(8).to_s("F")
              puts (ask.amount * ask.price).round(8).to_s("F")
              return false
            end
          end
        end

        users.first.quote_currency_balance = users.first.quote_currency_balance + bid_fee
        puts "Fee user have:"
        puts users.first.quote_currency_balance.round(8).to_s("F")

        #see users and balances
        users.each do |user|
          user.view_balances
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