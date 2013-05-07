require_relative "database.rb"
module DB_factory
  
  def db_instance
    db = Database_redis.new
  end
  
end