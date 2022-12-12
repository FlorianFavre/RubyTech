require_relative 'lib/market'
require 'bigdecimal'

market = Market.new
order_id = 1

puts "You want to trade on the BTC/EUR market."
puts "Create your first order: press enter to continue."
if gets.chomp != ""
  puts "No problem, you can create your first order later."
  exit
else
  puts "Transaction amount in BTC:"
  amount = BigDecimal(gets.chomp)
  puts "Transaction price in EUR:"
  price = BigDecimal(gets.chomp)
  puts "Buy (1) or sell (2):"
  side = gets.chomp.to_i

  order_a = [order_id, amount, price, side]
  order_id = order_id + 1
  market.submit(order_a)
  puts "You want to create a second order: press enter to continue."
  if gets.chomp != ""
    puts "It's ok you can create your second order later."
    exit
  else
    puts "Transaction amount in BTC:"
    amount = BigDecimal(gets.chomp)
    puts "Transaction price in EUR:"
    price = BigDecimal(gets.chomp)
    puts "Buy (1) or sell (2):"
    side = gets.chomp.to_i
    order_b = [order_id, amount, price, side]
    order_id = order_id + 1
    market.submit(order_b)

  end
end

puts "Market depth:"
puts market.market_depth

puts "Market price:"
puts market.market_price

puts "You want to cancel an order: press number to cancel it."
num_order_cancel = gets.chomp.to_i
if num_order_cancel != 1 && num_order_cancel != 2
  puts "No order was canceled"
  exit
else
  puts "Cancel order #{num_order_cancel}:"
  market.cancel_order(num_order_cancel)
end
