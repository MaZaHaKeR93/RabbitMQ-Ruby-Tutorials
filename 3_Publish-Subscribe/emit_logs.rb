#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

exchange = channel.fanout('logs')
# задаем тип обмена. В данном случае(fanout) доставляем сообщения всем очередям

message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message)
puts " [x] Sent #{message}"

connection.close
