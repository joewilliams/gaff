class Gaff
  class Ec2_api

    def self.exec(msg)
      parser = Yajl::Parser.new
      hash = parser.parse(msg)

      Gaff::Log.debug(hash)
      STDOUT.flush
      
      begin
        @ec2east = Fog::AWS::EC2.new(
          :aws_access_key_id => hash["params"]["aws_key"],
          :aws_secret_access_key => hash["params"]["aws_key_secret"],
          :region => "us-east-1")
        
        @ec2est = Fog::AWS::EC2.new(
          :aws_access_key_id => hash["params"]["aws_key"],
          :aws_secret_access_key => hash["params"]["aws_key_secret"],
          :region => "us-west-1")
        
        Gaff::Log.debug(@ec2east)
        Gaff::Log.debug(@ec2est)
        STDOUT.flush
                                
        case hash["method"]  
        when "attach_volume"
          if zone(hash["params"]["volume_id"]).include? "us-east-1"
            result = @ec2east.attach_volume(hash["params"]["instance_id"], hash["params"]["volume_id"], hash["params"]["device"])
          elsif zone(hash["params"]["volume_id"]).include? "us-west-1"
            result = @ec2est.attach_volume(hash["params"]["instance_id"], hash["params"]["volume_id"], hash["params"]["device"])
          end                          
        when "create_volume"
          if hash["params"]["availability_zone"].include? "us-east-1"
            result = @ec2east.create_volume(hash["params"]["availability_zone"], hash["params"]["size"].to_i, hash["params"]["snapshot_id"])
          elsif hash["params"]["availability_zone"].include? "us-west-1"
            result = @ec2est.create_volume(hash["params"]["availability_zone"], hash["params"]["size"].to_i, hash["params"]["snapshot_id"])
          end
        when "delete_volume"
          volume_id = hash["params"]["volume_id"]
          if zone(volume_id).include? "us-east-1"
            result = @ec2east.delete_volume(volume_id)
          elsif zone(volume_id).include? "us-west-1"
            result = @ec2est.delete_volume(volume_id)
          end
        when "detach_volume"
          if zone(hash["params"]["volume_id"]).include? "us-east-1"
            result = @ec2east.detach_volume(
              hash["params"]["volume_id"],
              {
                "InstanceId" => hash["params"]["instance_id"],
                "Device" => hash["params"]["device"],
                "Force" => hash["params"]["force"]
              })
          elsif zone(hash["params"]["volume_id"]).include? "us-west-1"
            result = @ec2est.detach_volume(
              hash["params"]["volume_id"],
              {
                "InstanceId" => hash["params"]["instance_id"],
                "Device" => hash["params"]["device"],
                "Force" => hash["params"]["force"]
              })
            end
        when "launch_instances"
          if hash["params"]["availability_zone"].include? "us-east-1"
            result = @ec2east.run_instances(
              hash["params"]["image_id"],
              hash["params"]["count"],
              hash["params"]["count"],
              {
    	          "SecurityGroup" => hash["params"]["group_ids"],
                "KeyName" => hash["params"]["key_name"],
                "Placement.AvailabilityZone" => hash["params"]["availability_zone"],
                "InstanceType" => hash["params"]["instance_type"]
              })
          elsif hash["params"]["availability_zone"].include? "us-west-1"
            result = @ec2est.run_instances(
              hash["params"]["image_id"],
              hash["params"]["count"],
              hash["params"]["count"],
              {
  	            "SecurityGroup" => hash["params"]["group_ids"],
                "KeyName" => hash["params"]["key_name"],
                "Placement.AvailabilityZone" => hash["params"]["availability_zone"],
                "InstanceType" => hash["params"]["instance_type"]
              })
          end
        when "reboot_instances"
          instance_ids = hash["params"]["instance_ids"]
          if zone(instance_ids).include? "us-east-1"
            result = @ec2east.reboot_instances(instance_ids)
          elsif zone(instance_ids).include? "us-west-1"
            result = @ec2est.reboot_instances(instance_ids)
          end
        when "terminate_instances"
          instance_ids = hash["params"]["instance_ids"]
          if zone(instance_ids).include? "us-east-1"
            result = @ec2east.terminate_instances(instance_ids)
          elsif zone(instance_ids).include? "us-west-1"
            result = @ec2est.terminate_instances(instance_ids)
          end
        end
        
        Gaff::Log.info(result)
        STDOUT.flush
      rescue Exception => e
        Gaff::Log.error(e)
        STDOUT.flush
      end
    end
    
    def self.zone(id)
      if id.include? "i-"
        begin
          @ec2east.describe_instances(id).body["reservationSet"].first["instancesSet"].first["placement"]["availabilityZone"]
        rescue
          @ec2est.describe_instances(id).body["reservationSet"].first["instancesSet"].first["placement"]["availabilityZone"]
        end
      elsif id.include? "vol-"
        begin
          @ec2east.describe_volumes(id).body["volumeSet"].first["availabilityZone"]
        rescue
          @ec2est.describe_volumes(id).body["volumeSet"].first["availabilityZone"]
        end
      end
    end

  end
end
