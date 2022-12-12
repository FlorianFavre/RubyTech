require_relative 'lib/market'
require 'bigdecimal'

market = Market.new
order_id = 1
action = 0

while action != 5
  puts "\n *************************** \n"
  puts "You want to trade on the BTC/EUR market. Choose your action"
  puts "Create order of trade number #{order_id}: press 1"
  puts "View the market depth: press 2"
  puts "View the Market price: press 3"
  puts "Cancel an order: press 4"
  puts "Exit: press 5"
  action = gets.chomp.to_i
  if action == 1
    puts "Transaction amount in BTC:"
    amount = BigDecimal(gets.chomp)
    puts "Transaction price in EUR:"
    price = BigDecimal(gets.chomp)
    puts "Buy (1) or sell (2):"
    side = gets.chomp.to_i

    order_a = {
      "order_id" => order_id,
      "amount" => amount,
      "price" => price,
      "side" => side
    }
    order_id = order_id + 1
    market.submit(order_a)
  end

  if action == 2
    puts "Market depth:"
    puts market.market_depth
  end

  if action == 3
    puts "Market price:"
    puts market.market_price
  end

  if action == 4
    puts "You want to cancel an order: press id of order you want to cancel."
    num_order_cancel = gets.chomp.to_i
    if num_order_cancel != 1 && num_order_cancel != 2
      puts "No order was canceled"
      exit
    else
      puts "Cancel order #{num_order_cancel}:"
      market.cancel_order(num_order_cancel)
    end
  end

  if action == 5
    exit
  end

end

