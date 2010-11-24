require 'rubygems'
require 'carrot'

exch = Carrot::AMQP::Exchange.new(Carrot.new, :topic, "api")

hash = {
  "method" => "add_a_record", 
  "params" => {
    "customer_name" => "gaff.com", 
    "username" => "username", 
    "password" => "password",
    "node" => "test123",
    "zone" => "gaff.com",
    "rdata" => "127.0.0.1",
    "ttl" => "300"
    }
}

exch.publish(hash.to_json, :routing_key => "dynect")