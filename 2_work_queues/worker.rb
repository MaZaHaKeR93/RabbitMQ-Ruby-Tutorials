#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue = channel.queue('task_queue', durable: true)
#durable - даже если RabbitMQ умрет, он сохранит очереди и сообщения и в след запуск все норм будет

channel.prefetch(1)
# 1 - не отправляй сообщение подписчику, если он еще не подтвердил прошлое выполнение задачи

puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  #manual_ack - нужно ли подтверждать очередь о том, что сообщение обработано и выполнено
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    puts " [x] Received #{body}"
    # imitate some work
    sleep body.count('.').to_i
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag) # оповещает очередь о том, что сообщение обработано и выполнено
  end
rescue Interrupt => _
  connection.close
end