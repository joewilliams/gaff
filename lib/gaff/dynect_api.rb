class Gaff
  class Dynect_api

    def self.exec(msg)
      parser = Yajl::Parser.new
      hash = parser.parse(msg)
 
      Gaff::Log.debug(hash)
      STDOUT.flush
      
      begin
        dynect = DynectRest.new(
          hash["params"]["customer_name"], 
          hash["params"]["username"], 
          hash["params"]["password"], 
          hash["params"]["zone"])
                            
        Gaff::Log.debug(dynect)
        STDOUT.flush
  
        case hash["method"]
        when "add_a_record"
          result = dynect.a.fqdn("#{hash["params"]["node"]}.#{hash["params"]["zone"]}").ttl(hash["params"]["ttl"]).address(hash["params"]["rdata"]).save
          publish = dynect.publish
        when "add_cname_record"
          result = dynect.cname.fqdn("#{hash["params"]["node"]}.#{hash["params"]["zone"]}").ttl(hash["params"]["ttl"]).cname(hash["params"]["rdata"]).save
          publish = dynect.publish  
        when "delete_a_record"
          result = dynect.a.fqdn("#{hash["params"]["node"]}.#{hash["params"]["zone"]}").delete
          publish = dynect.publish
        when "delete_cname_record"
          result = dynect.cname.fqdn("#{hash["params"]["node"]}.#{hash["params"]["zone"]}").delete
          publish = dynect.publish
        end
        
        Gaff::Log.info(result)
        Gaff::Log.debug(publish)
        STDOUT.flush        
      rescue Exception => e
        Gaff::Log.error(e)
        STDOUT.flush
      end
    end

  end
end
