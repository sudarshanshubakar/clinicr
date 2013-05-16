module Finder
  def get_matching_keys(user_id, location, criteria)
    details_keys = @redis.hkeys("#{user_id}:patient:#{location}")
    matching_keys = details_keys.grep(/^#{criteria}/)
  end
end


module Detail_finder 
  include Finder

  def find_details(user_id, criteria_string)
    matching_keys = get_matching_keys("details", user_id, criteria_string)
    matching_values = []
    matching_keys.each do |key|
      value = @redis.hget("#{user_id}:patient:details", key)
      puts "#{key} === #{value}"
      hash_result = JSON.parse(value)
      hash_result["id"] = key
      matching_values << hash_result
    end
    return matching_values
  end
end

module Reference_finder
  include Finder
  def find_reference(user_id, criteria_string)
    matching_keys = get_matching_keys("reference", user_id, criteria_string)
    matching_values = []
    matching_keys.each do |key|
      patient_id = @redis.hget("#{user_id}:patient:reference", key)
      details = @redis.hget("#{user_id}:patient:details", patient_id)
      hash_result = JSON.parse(details)
      hash_result["id"] = patient_id
      matching_values << hash_result
    end
    return matching_values
  end
end