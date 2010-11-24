require 'rubygems'
require 'carrot'

exch = Carrot::AMQP::Exchange.new(Carrot.new, :topic, "api")

slice = {
  "method" => "create_slice",
  "params" => {
    "password" => "password",
    "name" => "name123",
    "image_id" => 123,
    "flavor_id" => 123
  }
}

exch.publish(slice.to_json, :key => "slicehost")