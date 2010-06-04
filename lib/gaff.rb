require 'rubygems'

require 'mq'
require 'yajl'
require 'dynect'
require 'fog'
require 'mixlib/config'
require 'mixlib/log'
require 'yaml'

__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

require 'gaff/log'
require 'gaff/config'
require 'gaff/dispatch'
require 'gaff/ec2_api'
require 'gaff/slicehost_api'
require 'gaff/dynect_api'