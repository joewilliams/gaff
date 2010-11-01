class Gaff
  class Slicehost_api

    def self.exec(msg)
      parser = Yajl::Parser.new
      hash = parser.parse(msg)
 
      Gaff::Log.debug(hash)
      STDOUT.flush

      begin
        slicehost = Fog::Slicehost::Compute.new({:slicehost_password => hash["params"]["password"]})
  
        Gaff::Log.debug(slicehost)
        STDOUT.flush
        
        case hash["method"]      
        when "create_slice"
          result = slicehost.create_slice(
            hash["params"]["flavor_id"].to_i,
            hash["params"]["image_id"].to_i,
            hash["params"]["name"])
        when "delete_slice"
          result = slicehost.delete_slice(hash["params"]["slice_id"].to_i)   
        end
        
        Gaff::Log.info(result)
        STDOUT.flush
      rescue Exception => e
        Gaff::Log.error(e)
        STDOUT.flush
      end
    end

  end
end
