#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.direct('direct_logs')
# создает тип обмена 'direct'.
# Обмен между отправителем/получаетелем будет производиться через routing_key (одинаковые значения)


severity = ARGV.shift || 'info'
message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message, routing_key: severity)
# Получить сообщение может только тот, у кого routing_key выставлен с тем же значением.

puts " [x] Sent '#{message}'"

connection.close