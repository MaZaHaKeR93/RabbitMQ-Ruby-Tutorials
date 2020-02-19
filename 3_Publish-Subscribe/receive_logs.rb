#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout('logs')

queue = channel.queue('', exclusive: true)
# задаем рандомное название очереди
# Когда соединение, которое объявило это, закрывается, очередь будет удалена,
# потому что очередь была объявлена как уникальная.


queue.bind(exchange)
# говорим, что надо отправлять сообщения в очередь 'logs'
# Грубо говоря связываем очередь и тип обмена
# Привязка - это связь между обменом и очередью.

puts ' [*] Waiting for logs. To exit press CTRL+C'

begin
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  channel.close
  connection.close
end