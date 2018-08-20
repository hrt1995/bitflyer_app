require './method'

while(1)
  current_price = get_price
  puts current_price

  buy_price = 450000
  sell_price = 500000
  if (current_price > sell_price) && (balance("BTC")["amount"]>0.001)
    puts "売ります"
    order("SELL", sell_price, 0.001)
  elsif (current_price < buy_price) && (balance("JPY")["amount"]>1000)
    puts "買います"
    order("BUY", buy_price, 0.001)
  else
    puts "何もしません"
  end

  sleep(1)
end
