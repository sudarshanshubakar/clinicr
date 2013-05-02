require 'redis'
class Database
  def initialize
    @redis = Redis.new
  end
  
  def add_patient(id, details_hash)
    details_entry = get_details_entry(details_hash)
    name = details_hash["Name"]
    contact = details_hash["Contact"]
    @redis.hset("patient:details", id, details_entry)
    @redis.hset("patient:reference", name, id)
    @redis.hset("patient:reference", contact, id)
  end
  
  def add_history_entry(id, timestamp, history_entry)
    history_key = "visit_history:#{id}:#{timestamp}"
    @redis.set(history_key, history_entry)
    patient_history_key = "visit_history:#{id}"
    weight = @redis.zcount(patient_history_key, "-inf", "+inf") + 1
    @redis.zadd(patient_history_key, weight, history_key)
  end
  
  # Low level function. Not recommended for use from higher level functions. Use generate_id in Auto_generator(autogenerator.rb) instead.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
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