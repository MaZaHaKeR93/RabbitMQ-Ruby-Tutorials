#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)
#durable - даже если RabbitMQ умрет, он сохранит очереди и сообщения и в след запуск все норм будет

message = ARGV.empty? ? 'Hello world!' : ARGV.join(' ')

queue.publish(message, persistent: true)
# persistent - помечает сообщения как постоянные (сохраняет их на диск)
puts " [x] Sent #{message}"
connection.close