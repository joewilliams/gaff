class Gaff
  class Config
    gaff_config = YAML.load(File.open(ARGV[0]))
    extend Mixlib::Config
    configure do |c|
      c[:amqp_host] = gaff_config["defaults"]["amqp_host"]
      c[:ec2] = gaff_config["defaults"]["api"]["ec2"]
      c[:slicehost] = gaff_config["defaults"]["api"]["slicehost"]
      c[:dynect] = gaff_config["defaults"]["api"]["dynect"]
    end
  end
end
