require_relative "database.rb"
require_relative "configuration.rb"

module DB_factory
  
  def db_instance
    db = Database_redis.new
  end
end

module Config_factory
  
  def config_instance
    config = Configuration_redis.new
  end
end