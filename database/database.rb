require 'redis'
require_relative 'helpers/finders.rb'
class Database_redis
  include Detail_finder, Reference_finder
  def initialize
    @redis = Redis.new
  end

  def update_patient(user_id, patient_id, details_hash)
    puts "patient_id = #{patient_id}"
    puts "user_id = #{user_id}"
    puts "details = #{details_hash}"
    update_patient_details(user_id, patient_id, details_hash)
  end
  
  def find_patient(user_id, criteria)
    result = find_details(user_id, criteria)# get_result_from_details(criteria_string)
    if (result.empty?)
      result = find_reference(user_id, criteria)
    end
    puts "RESULT == #{result}"
    return result
  end



  def get_patient_details(user_id, patient_id)
    details = @redis.hget("#{user_id}:patient:details", patient_id)
    return details
  end

  def get_visit_history(user_id, patient_id)
    history_references = @redis.zrevrange("#{user_id}:visit_history:#{patient_id}", 0, -1)
    history_entries = get_history_entries(history_references)

  end

  def add_patient(user_id, patient_id, details_hash)
    update_patient_details(user_id, patient_id, details_hash)
  end
  
  def update_patient_details(user_id, patient_id, details_hash)
    details_entry = hash_to_json_string(details_hash)
    name = details_hash["name"]
    contact = details_hash["contact"]
    @redis.hset("#{user_id}:patient:details", patient_id, details_entry)
    @redis.hset("#{user_id}:patient:reference", name, patient_id)
    @redis.hset("#{user_id}:patient:reference", contact, patient_id)    
  end

  def add_history_entry(user_id, patient_id, timestamp, history_entry)
    history_key = "#{user_id}:visit_history:#{patient_id}:#{timestamp}"
    @redis.set(history_key, history_entry)
    patient_history_key = "#{user_id}:visit_history:#{patient_id}"
    weight = @redis.zcount(patient_history_key, "-inf", "+inf") + 1
    @redis.zadd(patient_history_key, weight, history_key)
  end

  # Low level function. Not recommended for use from higher level functions. Use generate_id in Auto_generator(autogenerator.rb) instead.
  def generate_id(user_id)
    cur_value = @redis.get("#{user_id}:id_gen:patient:current_value")
    id = cur_value.to_i + 1
    @redis.set("#{user_id}:id_gen:patient:current_value", id)
    return id
  end

  private
  def get_history_entries(history_references)
    history_entries = []
    history_references.each do |hist_ref_id|
      date = hist_ref_id.split(":")[3]
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