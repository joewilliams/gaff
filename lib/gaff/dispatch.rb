class Gaff
  class Dispatch

    def self.loop
      Signal.trap('INT') { AMQP.stop{ EM.stop } }
      Signal.trap('TERM'){ AMQP.stop{ EM.stop } }
      
      list = Array.new
      
      Gaff::Log.info("Starting Gaff dispatch loop ...")
      STDOUT.flush
      
      EM.run do
        exch = MQ::Exchange.new(MQ.new, :topic, "api", :host => Gaff::Config.amqp_host)

        MQ.queue(Gaff::Config.ec2).bind(exch, :key => Gaff::Config.ec2).subscribe do |msg|
          list << Thread.new { Gaff::Ec2_api.exec(msg) }
        end

        MQ.queue(Gaff::Config.slicehost).bind(exch, :key => Gaff::Config.slicehost).subscribe do |msg|
          list << Thread.new { Gaff::Slicehost_api.exec(msg) }
        end

        MQ.queue(Gaff::Config.dynect).bind(exch, :key => Gaff::Config.dynect).subscribe do |msg|
          list << Thread.new { Gaff::Dynect_api.exec(msg) }
        end
      end
    
      list.each { |x|
     	    x.join
      }
    end
  end
end
