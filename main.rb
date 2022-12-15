require_relative 'lib/market'
require 'bigdecimal'

market = Market.new
order_id = 1
action = 0

#-------------------Test-------------------

order = {
  "order_id" => order_id,
  "amount" => BigDecimal("0.0000254"),
  "price" => BigDecimal("100.0"),
  "side" => 1
}
order_id = order_id + 1
market.submit(order)
order = {
  "order_id" => order_id,
  "amount" => BigDecimal("0.000214"),
  "price" => BigDecimal("200.0"),
  "side" => 1
}
order_id = order_id + 1
market.submit(order)
order = {
  "order_id" => order_id,
  "amount" => BigDecimal("1.1254"),
  "price" => BigDecimal("300.00"),
  "side" => 2
}
order_id = order_id + 1
market.submit(order)
order = {
  "order_id" => order_id,
  "amount" => BigDecimal("0.36985"),
  "price" => BigDecimal("400.00"),
  "side" => 2
}
order_id = order_id + 1
market.submit(order)

#-------------------Menu-------------------

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

    order = {
      "order_id" => order_id,
      "amount" => amount,
      "price" => price,
      "side" => side
    }
    order_id = order_id + 1
    market.submit(order)
  end

  if action == 2
    puts "Market depth:"
    puts market.market_depth
  end

  if action == 3
    puts "Market price:"
    market.market_price
  end

  if action == 4
    puts "You want to cancel an order: press id of order you want to cancel."
    num_order_cancel = gets.chomp.to_i
    if num_order_cancel > order_id
      puts "No order was canceled with this id."
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

