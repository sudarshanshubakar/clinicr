require 'redis'
class Add_patient
  
  def initialize
    @redis = Redis.new
  end
  
  def do(params)
    id = generate_id
    details_entry = get_details_entry(params)
    name = params["Name"]
    contact = params["Contact"]
    @redis.hset("patient:details", id, details_entry)
    @redis.hset("patient:reference", name, id)
    @redis.hset("patient:reference", contact, id)
    
    date = Time.now.strftime("%d-%b-%Y %I.%M%p")
    history_key = "visit_history:#{id}:#{date}"
    history_entry = "Added patient. First visit details follow."
    @redis.set(history_key, history_entry)
    
    patient_history_key = "visit_history:#{id}"
    weight = @redis.zcount(patient_history_key, "-inf", "+inf") + 1
    @redis.zadd(patient_history_key, weight, history_key)
    
    # 
    # 
    # patient_history_key = "visit_history:#{id}"
    # weight = @redis.zcount(patient_history_key, "-inf", "+inf") + 1
    # @redis.zadd(patient_history_key, weight, "Added patient. First visit details follow.")
    return id
  end
  
  def generate_id
    cur_value = @redis.get("id_gen:patient:current_value")
    id = cur_value.to_i + 1
    @redis.set("id_gen:patient:current_value", id)
    return id
  end
  
  private
  def get_details_entry(params)
    details_entry = params.to_s
    details_entry = details_entry.gsub '=>', ':'
    return details_entry
  end
  
end