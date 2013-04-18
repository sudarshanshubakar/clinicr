require 'redis'
class Update_visit
  
  def do(params)
    redis = Redis.new
    id = params["id"]
    date = Time.now.strftime("%d-%b-%Y %I.%M%p")
    history_key = "visit_history:#{id}:#{date}"
    history_entry = get_history_entry(params)
    redis.set(history_key, history_entry)
    
    patient_history_key = "visit_history:#{id}"
    weight = redis.zcount(patient_history_key, "-inf", "+inf") + 1
    redis.zadd(patient_history_key, weight, history_key)
  end
  
  private
  def get_history_entry(params)
    params.delete("id")
    history_entry = params.to_s
    history_entry = history_entry.gsub '=>', ':'
    return history_entry
  end
end