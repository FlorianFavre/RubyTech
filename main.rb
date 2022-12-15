require_relative 'lib/market'
require_relative 'lib/user'
require_relative 'lib/order'
require 'bigdecimal'

#create a array of 4 users
users = []
user_id = 1
market = Market.new
order_id = 1
action = 0
orders = []

#add 4 users to the array users

#initial user1 balance
user1 = User.new(user_id, "Flo", "flo@test.com", BigDecimal("1"), BigDecimal("1000"))
user_id = user_id + 1
users.push(user1)

#initial user2 balance
user2 = User.new(user_id, "Mike", "Mike@test.com", BigDecimal("1"), BigDecimal("1000"))
user_id = user_id + 1
users.push(user2)

#initial user3 balance
user3 = User.new(user_id, "John", "John@test.com", BigDecimal("1"), BigDecimal("1000"))
user_id = user_id + 1
users.push(user3)

#initial user4 balance
user4 = User.new(user_id, "Jane", "Jane]test.com", BigDecimal("1"), BigDecimal("1000"))
user_id = user_id + 1
users.push(user4)

#-------------------Test-------------------
order = Order.new(order_id, 1, BigDecimal("1"), BigDecimal("1000"), 1)
order_id = order_id + 1
if user1.add_order(order)
  market.submit(order, users, orders)
  orders.push(order)
end

order = Order.new(order_id, 1, BigDecimal("1"), BigDecimal("1000"), 2)
order_id = order_id + 1
user2.add_order(order)
market.submit(order, users, orders)
orders.push(order)

order = Order.new(order_id, 2, BigDecimal("1"), BigDecimal("1000"), 3)
order_id = order_id + 1
user3.add_order(order)
market.submit(order, users, orders)
orders.push(order)

order = Order.new(order_id, 2, BigDecimal("1"), BigDecimal("1000"), 4)
order_id = order_id + 1
user4.add_order(order)
market.submit(order, users, orders)
orders.push(order)

#-------------------Menu-------------------
puts "\n *************************** \n"
puts "You want to trade on the BTC/EUR market. Give me your name"
name = gets.chomp
puts "Give me your email"
email = gets.chomp
user = users.find { |user| user.name == name && user.email == email }
if user
  while action != 5  
    puts "Welcome #{user.name}"
    puts "Choose your action"
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

      Order.new(order_id, 1, BigDecimal("100.0"), BigDecimal("1"), 1)

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

end

