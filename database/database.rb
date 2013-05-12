require 'redis'
require_relative 'helpers/finders.rb'
class Database_redis
  include Detail_finder, Reference_finder
  def initialize
    @redis = Redis.new
  end

  def update_patient(id, details_hash)
    puts "ID = #{id}"
    puts "details = #{details_hash}"
    update_patient_details(id, details_hash)
  end
  
  def find_patient(criteria)
    result = find_details(criteria)# get_result_from_details(criteria_string)
    if (result.empty?)
      result = find_reference(criteria)
    end
    puts "RESULT == #{result}"
    return result
  end



  def get_patient_details(id)
    details = @redis.hget("patient:details", id)
    return details
  end

  def get_visit_history(id)
    history_references = @redis.zrevrange("visit_history:#{id}", 0, -1)
    history_entries = get_history_entries(id, history_references)

  end

  def add_patient(id, details_hash)
    update_patient_details(id, details_hash)
  end
  
  def update_patient_details(id, details_hash)
    details_entry = hash_to_json_string(details_hash)
    name = details_hash["name"]
    contact = details_hash["contact"]
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
  def get_history_entries(id, history_references)
    history_entries = []
    history_references.each do |hist_ref_id|
      date = hist_ref_id.split(":")[2]
      history_value = @redis.get(hist_ref_id)
      history_entries << "#{date}||#{history_value}"
    end
    return history_entries
  end

  def hash_to_json_string(params)
    details_entry = params.to_s
    details_entry = details_entry.gsub '=>', ':'
    return details_entry
  end
end