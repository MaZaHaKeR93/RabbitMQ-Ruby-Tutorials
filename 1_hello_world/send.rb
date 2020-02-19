#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue = channel.queue('hello')
channel.default_exchange.publish('Hello, world!', routing_key: queue.name)
# routing_key -   отправлять сообщения в указанную очередь
puts " [x] Sent 'Hello World!'"
connection.close