require_relative 'lib/market'
require_relative 'lib/market_bitcoin'
require_relative 'lib/market_ethereum'
require_relative 'lib/user'
require_relative 'lib/order'
require 'bigdecimal'
require 'bigdecimal/util'

#create a array of 4 users
users = []
user_id = 1
market_bitcoin = Market_Bitcoin.new
market_ethereum = Market_Ethereum.new
order_id = 1
action = 0
orders = []

#create fee user
fee_user = User.new(user_id, "Fee", "admin@paymi.com", BigDecimal("0"), BigDecimal("0"), BigDecimal("0"))
user_id = user_id + 1
users.push(fee_user)

#initial user1 balance
user2 = User.new(user_id, "Flo", "flo@test.com", BigDecimal("95000"), BigDecimal("0"), BigDecimal("0"))
user_id = user_id + 1
users.push(user2)

#initial user2 balance
user3 = User.new(user_id, "John", "John@test.com", BigDecimal("0"), BigDecimal("3"), BigDecimal("2"))
user_id = user_id + 1
users.push(user3)

#-------------------Test Bitcoin -------------------
order = Order.new(order_id, 1, BigDecimal("27000"), BigDecimal("1"), 2, "Bitcoin")
order_id = order_id + 1
if user2.add_order(order)
  market_bitcoin.submit(order)
  market_bitcoin.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end

order = Order.new(order_id, 2, BigDecimal("27000"), BigDecimal("1"), 3, "Bitcoin")
order_id = order_id + 1
if user3.add_order(order)
  market_bitcoin.submit(order)
  market_bitcoin.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end

#-------------------Test Ethereum -------------------
order = Order.new(order_id, 1, BigDecimal("27000"), BigDecimal("1"), 2, "Ethereum")
order_id = order_id + 1
if user2.add_order(order)
  market_ethereum.submit(order)
  market_ethereum.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end

order = Order.new(order_id, 2, BigDecimal("27000"), BigDecimal("1"), 3, "Ethereum")
order_id = order_id + 1
if user3.add_order(order)
  market_ethereum.submit(order)
  market_ethereum.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end