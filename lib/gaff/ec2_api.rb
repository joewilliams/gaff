class Gaff
  class Ec2_api

    def self.exec(msg)
      parser = Yajl::Parser.new
      hash = parser.parse(msg)

      Gaff::Log.debug(hash)
      STDOUT.flush
     
      ec2 = Fog::AWS::EC2.new(
        :aws_access_key_id => hash["params"]["aws_key"],
        :aws_secret_access_key => hash["params"]["aws_key_secret"])
      
      Gaff::Log.debug(ec2)
      STDOUT.flush
                              
      case hash["method"]  
      when "attach_volume"
        result = ec2.attach_volume(
          hash["params"]["volume_id"],
          hash["params"]["instance_id"],
          hash["params"]["device"])                            
      when "create_volume"
        result = ec2.create_volume(
          hash["params"]["availability_zone"],
          hash["params"]["size"].to_i,
          hash["params"]["snapshot_id"])
      when "delete_volume"
        result = ec2.delete_volume(hash["params"]["volume_id"])
      when "detach_volume"
        result = ec2.detach_volume(
          hash["params"]["volume_id"],
          hash["params"]["instance_id"],
          hash["params"]["device"],
          hash["params"]["force"])
      when "launch_instances"
        result = ec2.run_instances(
          hash["params"]["image_id"],
          hash["params"]["count"],
          hash["params"]["count"],
          {
        	  "SecurityGroup" => hash["params"]["group_ids"],
            "KeyName" => hash["params"]["key_name"],
            "Placement.AvailabilityZone" => hash["params"]["availability_zone"],
            "InstanceType" => hash["params"]["instance_type"]
          })
      when "reboot_instances"
        result = ec2.reboot_instances(hash["params"]["instance_ids"])
      when "terminate_instances"
        result = ec2.terminate_instances(hash["params"]["instance_ids"])
      end
      
      Gaff::Log.info(result)
      STDOUT.flush
    end

  end
end
