require_relative 'lib/market'
require_relative 'lib/user'
require_relative 'lib/order'
require 'bigdecimal'
require 'bigdecimal/util'

#create a array of 4 users
users = []
user_id = 1
market = Market.new
order_id = 1
action = 0
orders = []

#create fee user
fee_user = User.new(user_id, "Fee", "admin@paymi.com", BigDecimal("0"), BigDecimal("0"))
user_id = user_id + 1
users.push(fee_user)

#initial user1 balance
user2 = User.new(user_id, "Flo", "flo@test.com", BigDecimal("45000"), BigDecimal("0"))
user_id = user_id + 1
users.push(user2)

#initial user2 balance
user3 = User.new(user_id, "John", "John@test.com", BigDecimal("0"), BigDecimal("3"))
user_id = user_id + 1
users.push(user3)

#-------------------Test-------------------
order = Order.new(order_id, 1, BigDecimal("27000"), BigDecimal("1"), 2)
order_id = order_id + 1
if user2.add_order(order)
  market.submit(order)
  market.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end

order = Order.new(order_id, 2, BigDecimal("27000"), BigDecimal("1"), 3)
order_id = order_id + 1
if user3.add_order(order)
  market.submit(order)
  market.match(order, users, orders)
  orders.push(order)
else
  puts "Order not submitted"
end


#-------------------Menu-------------------
=begin
puts "\n *************************** \n"
puts "You want to trade on the BTC/EUR market. Give me your name"
name = gets.chomp
puts "Give me your email"
email = gets.chomp
user = users.find { |user| user.name == name && user.email == email }
if user
  users.push(user)
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

      Order.new(order_id, 1, price, amount, 1)

      order = {
        "order_id" => order_id,
        "amount" => amount,
        "price" => price,
        "side" => side
      }
      order_id = order_id + 1
      if user.add_order(order)
        market.submit(order, users, orders)
        orders.push(order)
      end
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
=end
