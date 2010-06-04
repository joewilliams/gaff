class Gaff
  class Dynect_api

    def self.exec(msg)
      parser = Yajl::Parser.new
      hash = parser.parse(msg)
 
      Gaff::Log.debug(hash)
      STDOUT.flush

      dynect = Dynect.new(
        hash["params"]["customer_name"], 
        hash["params"]["username"], 
        hash["params"]["password"])
                          
      Gaff::Log.debug(dynect)
      STDOUT.flush

      case hash["method"]
      when "add_a_record"
        node = dynect.add_node(
          hash["params"]["node"], 
          hash["params"]["zone"])
                               
        record = dynect.add_a_record(
          hash["params"]["zone"],
          hash["params"]["address"], 
          {
            "node" => "#{hash["params"]["node"]}.#{hash["params"]["zone"]}", 
            "ttl" => hash["params"]["ttl"]
          })
      when "add_cname_record"
        node = dynect.add_node(
          hash["params"]["node"],
          hash["params"]["zone"])
        
        record = dynect.add_cname_record(
          hash["params"]["zone"],
          hash["params"]["address"],
          {
            "node" => "#{hash["params"]["node"]}.#{hash["params"]["zone"]}", 
            "ttl" => hash["params"]["ttl"]
          })
      when "delete_a_record"
        record_id = dynect.list_a_records(
          hash["params"]["zone"], 
          {
            "node" => "#{hash["params"]["node"]}.#{hash["params"]["zone"]}"
          })
                                          
        record = dynect.delete_a_record(record_id[0]["record_id"])
      when "delete_cname_record"
        record_id = dynect.list_cname_records(
          hash["params"]["zone"], 
          {
            "node" => "#{hash["params"]["node"]}.#{hash["params"]["zone"]}"
          })
        
        record = dynect.delete_cname_record(record_id[0]["record_id"])
      end
      
      if node
        Gaff::Log.debug(node.inspect)
        node = nil
      end
      Gaff::Log.info(record.inspect)
      STDOUT.flush
    end

  end
end
