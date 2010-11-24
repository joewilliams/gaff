require 'rubygems'
require 'carrot'

exch = Carrot::AMQP::Exchange.new(Carrot.new, :topic, "api")

new_instance = {
  "method" => "launch_instances",
  "params" => {
    "aws_key" => "key",
    "aws_key_secret" => "secret",
    "count" => 1,
    "image_id" => "ami-xxxx",
    "group_ids" => ["default"],
    "addressing_type" => "public",
    "key_name" => "key",
    "availability_zone" => "us-east-1a",
    "instance_type" => "c1.medium",
    "region" => "us-east-1"
  }
}

exch.publish(new_instance.to_json, :key => "ec2")