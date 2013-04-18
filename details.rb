require 'redis'

class Details
  
  def get(id)
    
    redis = Redis.new
    details = redis.hget("patient:details", id)
    return details
  end
  
end